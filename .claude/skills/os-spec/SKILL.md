---
name: os-spec
description: OpenSpec 规约阶段——编写 Delta spec，GIVEN/WHEN/THEN Scenario 定义。当 proposal 确认后调用。
---

# os-spec：规约编写

## 何时调用

Proposal 获用户确认后，进入 Specs 阶段。

## 工作流

Delta spec 的每个 `#### Scenario` 直接对应一条测试用例。**每个 Requirement 至少包含一个异常/边界 Scenario**：

```markdown
# Delta for Auth

## ADDED Requirements

### Requirement: Password Reset Confirmation
系统 SHALL 验证 reset token 并允许用户设置新密码。

#### Scenario: Valid token（正常路径）
- GIVEN 一个有效的 reset token
- WHEN 用户提交新密码
- THEN 返回 200 状态码
- AND 密码被更新

#### Scenario: Expired token（异常路径）
- GIVEN 一个已过期的 reset token
- WHEN 用户尝试重置密码
- THEN 返回 410 状态码

#### Scenario: Empty new password（边界条件）
- GIVEN 一个有效的 reset token
- WHEN 用户提交空字符串作为新密码
- THEN 返回 400 状态码
```

## 规则

- **只描述可观测行为**。类名、函数名、框架选择、SQL 语句属于 design 或 tasks。
- **新领域创建：** 如果 `specs/<domain>/` 目录尚不存在，创建新目录和 `spec.md`，内容只包含本次变更涉及的 Requirement。
- **跨 domain 变更：** 一个变更涉及多个领域时，在 `changes/<name>/specs/<domain1>/spec.md`、`<domain2>/spec.md` 下各写一个 delta spec。

## Spec → 测试映射

| Spec 元素 | 测试结构 |
|-----------|---------|
| `### Requirement: <名称>` | 测试组：如 describe/class/module（依语言而定） |
| `#### Scenario: <描述>` | 测试用例：如 it/def test_/@Test（依语言而定） |
| `- GIVEN <状态>` | Arrange：构造输入和前置状态 |
| `- WHEN <触发>` | Act：调用被测单元 |
| `- THEN <预期>` | Assert：断言结果值 |
| `- AND <附加>` | 同一测试用例内追加 Assert |

## 完成后

用户确认 spec → 调用 `os-design`。

## 示例

**模型：**
```
[WORKFLOW] 判定表情况: 新功能 → specs → design → tasks → TDD → archive
[WORKFLOW] 当前阶段: Specs
[WORKFLOW] 前置条件: Proposal 已获用户确认

### 第二步：Specs

创建 openspec/changes/add-password-reset/specs/auth/spec.md：

---
# Delta for Auth

## ADDED Requirements

### Requirement: Password Reset Request
系统 SHALL 允许用户通过邮箱发起密码重置请求。

#### Scenario: Successful reset request（正常路径）
- GIVEN 一个已注册的用户
- WHEN 用户请求密码重置
- THEN 返回 200 状态码
- AND 生成一个有效期 30 分钟的 reset token

#### Scenario: Non-existent user（安全防护）
- GIVEN 一个未注册的邮箱
- WHEN 用户请求密码重置
- THEN 仍然返回 200 状态码
- AND 不生成任何 token
---

若无异议，我继续 design。
```
