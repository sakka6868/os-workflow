---
name: os-fork
description: Git Worktree 隔离开发——多模块/高风险变更前创建独立工作区。当涉及多模块变更或用户明确要求时调用。在 os-plan 或 os-trace 之前作为前置步骤执行。
---

# os-fork：Git Worktree 隔离

## 何时调用

涉及多模块的变更、高风险重构、需要并行开发多个独立功能时。

## 步骤

1. **检测当前隔离状态：** 是否已在 worktree 中？如果是 → 跳到步骤 3。
2. **创建隔离工作区：** 优先使用 Claude Code 的 `EnterWorktree` 工具。只有在原生工具不可用时才回退到 `git worktree add`。
3. **项目初始化：** 自动检测并运行依赖安装（npm/yarn、mvn、pip、cargo 等）。
4. **验证基线：** 运行全量测试确认基线绿色。有失败则报告，不继续。

## 隔离原则

- 每个独立变更在自己的 worktree 中进行
- 禁止在 main/master 分支上直接开发（除非用户明确要求）
- 完成后用 `ExitWorktree` 离开，由用户决定保留或删除

## 完成后

Worktree 就绪 + 基线绿色 → 调用 `os-plan`（新功能/重构）或 `os-trace`（Bug 修复）。
