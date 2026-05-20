---
name: os-plan
description: OpenSpec 提案阶段——方案设计、多方案对比、YAGNI 审查、分段确认。当判定表匹配到 Propose 阶段时调用。
---

# os-plan：提案与方案设计

## 何时调用

判定表匹配到 Propose 阶段（新功能、API 契约变更），或 `os-scope` 澄清完成后。

## 工作流

收到变更请求**不直接写代码**。先创建 `openspec/changes/<kebab-case-name>/proposal.md`：

```markdown
# Proposal: <功能名称>

## Intent
要解决什么问题？为什么需要这个变更？

## Scope
范围内：特性 A、特性 B
范围外：特性 C（后续迭代）

## Approaches Considered（2-3 个备选方案）
### 方案 A: <名称>
- 描述
- 优点 / 缺点
### 方案 B: <名称>
- 描述
- 优点 / 缺点
### 推荐方案: <A/B>，原因：<简要理由>

## Approach（选定方案的详细描述）
总体实现方案概述。

## YAGNI 审查
以下内容刻意排除，不做过度设计：
- 不需要的特性 X（因为用户未要求 / 使用场景不存在）
- 不需要的抽象 Y（当前只有一个用例，等第二个出现再提取）
```

## 分段确认

先展示 Intent + Scope，用户确认后再展示 Approaches，确认推荐方案后再展开详细 Approach。不要一次性展示完整 proposal。

## 自检清单（展示给用户前）

- [ ] 所有占位符（TODO、TBD、待定）已消除
- [ ] Scope 边界明确——"范围内"和"范围外"都写清楚了
- [ ] 无歧义——每个术语能被新成员理解
- [ ] 无范围蔓延——未包含用户未要求的内容
- [ ] 多子系统请求已拆分——每个 change 只做一件事

## 约束

- Propose 阶段**只生成 proposal.md**，不生成 specs/design/tasks
- 用户确认后 → 调用 `os-spec`
- 用户提出修改但不推翻整体方案 → 在原 `proposal.md` 上直接修改
- 意图/范围发生根本改变 → 建新 change

## 示例

**用户：** "添加密码重置功能，可以通过邮箱发送重置链接"

**模型：**
```
[WORKFLOW] 判定表情况: 新功能 → 需求澄清 → propose → specs → design → tasks → TDD → archive
[WORKFLOW] 当前阶段: Propose
[WORKFLOW] 前置条件: 基线测试待确认

先跑基线测试确认当前全部通过：
> npm test
✓ 12 passed, 0 failed

### 第一步：Proposal

先展示 Intent + Scope，确认后再展开方案。

---
## Intent + Scope

**Intent:** 用户当前忘记密码后无法恢复账号，需要提供通过邮箱重置密码的能力。

**Scope 范围内：** POST /forgot-password 生成重置 token、POST /reset-password 验证 token 并更新密码
**范围外：** 短信验证码重置（后续迭代）、重置链接的邮件发送（仅生成 token，邮件由外部服务处理）
---

请先确认以上范围和意图是否准确。确认后我展开备选方案。
```

**用户：** "确认"

**模型：**
```
[WORKFLOW] 判定表情况: 新功能 → 当前仍处于 Propose 阶段（展开备选方案）
[WORKFLOW] 当前阶段: Propose
[WORKFLOW] 前置条件: Intent + Scope 已获用户确认

## Approaches Considered

### 方案 A: 内存存储 token
- token: crypto.randomBytes(32) → hex，SHA-256 hash 存入内存 Map
- 有效期: 30 分钟，过期自动清理
- 优点: 零依赖，实现简单
- 缺点: 服务重启丢失所有 token；多实例不共享

### 方案 B: 数据库存储 token
- token: JWT（自包含过期时间），数据库记录 token 状态
- 优点: 持久化，多实例共享，可审计
- 缺点: 增加 DB 查询，需新建表 + Flyway 迁移

### 推荐: 方案 A（当前阶段）
原因：用户规模小，单实例部署，服务重启频率低。后续需要多实例时再迁移到方案 B。

## Approach
使用 crypto.randomBytes(32).toString('hex') 生成 64 位 hex token，SHA-256 哈希后存入 ConcurrentHashMap，ScheduledExecutorService 每 5 分钟清理过期条目。

## YAGNI 审查
- 不做邮件发送——由外部邮件服务通过事件触发
- 不做 token 黑名单——单次使用后直接删除
- 不做重置次数限制——本期无暴力破解风险

请审查以上完整 proposal。确认后我进入 specs 阶段。
```
