---
name: os-ship
description: OpenSpec 归档阶段——合并 delta spec、运行全量测试、归档变更。当全部 task 完成后调用。
---

# os-ship：归档发布

## 何时调用

全部 task 完成（tasks.md 全部 `[x]`），Code Review 通过后。

## 归档步骤

```
1. 运行全部测试（如 `npm test`、`pytest`、`cargo test`，必须全部通过）
2. 手动合并 delta spec 到主 spec：
   - ADDED    → 将 Requirement 追加到 specs/<domain>/spec.md
   - MODIFIED → 用新内容替换 specs/<domain>/spec.md 中对应 Requirement
   - REMOVED  → 从 specs/<domain>/spec.md 中删除对应 Requirement
3. 将变更目录移入 changes/archive/YYYY-MM-DD-<name>/
```

**任一测试失败则停止归档** → 调用 `os-trace` 诊断根因 → 根据诊断结果路由到对应阶段修复（spec 错误 → `os-spec`；design 问题 → `os-design`；代码 bug → `os-build`）。

## 完成后

归档完成，变更已合入主 spec，流程结束。

## 示例

**模型：**
```
[WORKFLOW] 判定表情况: 新功能 → archive
[WORKFLOW] 当前阶段: Archive
[WORKFLOW] 前置条件: 全部 11 个任务已完成，tasks.md 全部 [x]

全部 11 个任务已完成，tasks.md 全部 [x]。

### 归档前检查

> npm test
✓ 18 passed, 0 failed

手动合并 delta spec → 主 spec：
- ADDED: "Password Reset Request" 和 "Password Reset Confirmation" 追加到 specs/auth/spec.md
- MODIFIED: "Invalid credentials" 覆盖主 spec 对应项

归档目录：
> mv openspec/changes/add-password-reset openspec/changes/archive/2026-05-06-add-password-reset/

归档完成。main spec 已更新，变更历史已保留。
```
