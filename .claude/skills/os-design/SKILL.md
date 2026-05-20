---
name: os-design
description: OpenSpec 设计+任务阶段——技术方案、测试策略、Spec→测试映射、任务拆分含依赖声明。当 spec 确认后调用。
---

# os-design：技术设计 + 任务拆分

## 何时调用

Spec 获用户确认后。

## 第三步：Design — 含测试策略

```markdown
# Design: <功能名称>

## Technical Approach
总体技术方案。

## Testing Strategy
- 测试框架：<根据项目语言选取，如 Vitest/Jest/Pytest/JUnit>
- 测试级别：单元测试 / 集成测试
- 文件位置：遵循项目现有测试目录约定
- Mock 策略：哪些外部依赖需要模拟
- 测试数据：如何构造测试数据（fixture / factory / inline）

## Spec → 测试结构映射
明确 Spec 中每个 Scenario 对应哪个测试文件、哪个 describe/it 块：

| Spec Scenario | 测试文件 | 测试用例 |
|--------------|---------|---------|
| Valid token | `tests/auth.test.ts` | `describe('POST /reset-password', () => { it('有效 token 返回 200') })` |
| Expired token | 同上 | `it('过期 token 返回 410')` |
| Empty password | 同上 | `it('空密码返回 400')` |

## Architecture Decisions
### Decision: <决策名称>
方案描述，原因。

## File Changes
（根据项目实际语言写文件名）
```

## 第四步：Tasks — 每项内嵌 RED→GREEN→REFACTOR

任务按逻辑分组，每组最后一个任务收尾 REFACTOR：

```markdown
# Tasks

## 1. Reset Token 基础设施
- [ ] 1.1 RED: 编写 token 生成（64 位 hex）和 hash 计算的测试
- [ ] 1.2 GREEN: 实现 token 生成和 hash 计算
- [ ] 1.3 REFACTOR: 提取过期时间常量

## 2. POST /forgot-password
- [ ] 2.1 RED: 编写存在用户返回 200、不存在用户返回 200 的测试
- [ ] 2.2 GREEN: 实现路由但暂不接入 token 生成
- [ ] 2.3 RED: 编写生成 token 并存储的测试
- [ ] 2.4 GREEN: 接入 token 生成和存储
- [ ] 2.5 REFACTOR: 抽取 token hash 工具函数

## 3. POST /reset-password
- [ ] 3.1 RED: 编写有效 token 和过期 token 的测试
- [ ] 3.2 GREEN: 实现密码更新路由（含过期校验）
- [ ] 3.3 REFACTOR: 抽取 token 校验逻辑
```

### 约束

- **每个需求组只设一个 REFACTOR 里程碑**，放在该组 GREEN 全部完成后。
- **依赖声明：** 每个 task 可标注 `blocks: [task-id]` 和/或 `blockedBy: [task-id]`，无标注的 task 视为可并行。示例：
  ```markdown
  - [ ] 2.1 RED: 编写测试 — blockedBy: [1.3]
  - [ ] 2.2 GREEN: 实现路由 — blockedBy: [2.1]
  ```

### 并行策略（MANDATORY — tasks.md 末尾必须包含）

根据**文件物理归属**将 task 组划分为多个 Wave。共享文件的 task 必须同 agent 串行；不共享文件的可分入不同 agent 并行。

```markdown
## 并行策略

### Wave 1（N agent 并行，blockedBy 为空的所有 task）
- [Agent A] <task-id 列表> — 涉及模块/文件：<文件列表>
- [Agent B] <task-id 列表> — 涉及模块/文件：<文件列表>

### Wave 2（M agent 并行，Wave 1 全部完成后 blockedBy 被满足的 task）
- [Agent A] <task-id 列表> — 涉及模块/文件：<文件列表>
- [Agent B] <task-id 列表> — 涉及模块/文件：<文件列表>
```

**规则：**

1. **文件归属分析**：遍历每个 `blockedBy` 为空的 task，列出其涉及的文件/目录。共享文件的 task 必须在同一 agent 内串行；完全不共享文件的可分入不同 agent 并行。
2. **Wave 划分**：Wave 1 = `blockedBy` 为空的全部 task。Wave N+1 = 前 N 波全部完成后 `blockedBy` 从 `[ ]` 变为 `[x]` 的 task。
3. **N ≥ 3 必须并行；N=2 推荐并行**：Wave 内可并行的 agent 数 ≥ 3 时 MUST 并发；N=2 且文件无重叠时 SHOULD 并发；N=1 串行。
4. **跨模块天然并行**：前后端 task 组涉及不同目录/文件，只要文件归属无重叠即可在不同 agent 中并行。os-build 实施时直接读取本并行策略执行，不再重新评估。
5. **禁止**：共享文件的 task 分入不同 agent；跳过并行策略声明直接写 tasks。

## 完成后

用户确认 design + tasks（含并行策略）→ 调用 `os-build` 进入 TDD 实施。
