---
name: os-ui
description: "UI/UX 设计智能 + 生产级前端代码生成。融合设计系统推荐（161 配色、57 字体搭配、99 UX 指南、25 图表类型、50+ 风格）与创意前端实现。两阶段流程：Phase 1 设计智能（数据驱动方案）→ Phase 2 创意实现（高审美代码生成）。支持 Web/React/Next.js/Vue/Svelte/SwiftUI/React Native/Flutter/Tailwind/shadcn/ui 等 10+ 技术栈。"
---

# UI Design — 设计智能 + 创意实现

融合两阶段工作流：**数据驱动的设计决策** → **高审美的前端实现**。

- **设计智能层**：基于 161 配色、57 字体搭配、99 UX 指南的结构化推荐系统，回答"该设计什么"
- **创意实现层**：基于审美方向和生产级代码要求的前端实现，回答"该怎么实现"

---

## 何时调用

### 必须使用

- 设计新页面（Landing Page / Dashboard / Admin / SaaS / 移动应用）
- 创建或重构 UI 组件（按钮、弹窗、表单、表格、图表等）
- 选择配色、字体、间距或布局系统
- Review UI 代码的用户体验、可访问性或视觉一致性
- 实现导航结构、动画或响应式行为
- 产品级设计决策（风格、信息层级、品牌表达）
- 改善界面的感知质量、清晰度或可用性

### 推荐使用

- UI 看起来"不够专业"但原因不明确
- 收到可用性或体验反馈
- 发布前 UI 质量优化
- 跨平台设计对齐（Web / iOS / Android）
- 构建设计系统或可复用组件库

### 跳过

- 纯后端逻辑开发
- 仅涉及 API 或数据库设计
- 与界面无关的性能优化
- 基础设施或 DevOps 工作
- 非视觉的脚本或自动化任务

**决策标准：** 如果任务会改变功能的**外观、感觉、动效或交互方式**，就应该使用本技能。

---

## 工作流概览

```
Phase 1: 设计智能（数据驱动）
  Step 1 → 分析需求 → 提取产品类型、受众、风格关键词
  Step 2 → 生成设计系统 → search.py --design-system
  Step 3 → 补充领域搜索 → search.py --domain <domain>

Phase 2: 创意实现（代码生成）
  Step 4 → 确定审美方向 → 选取大胆的视觉方向
  Step 5 → 实现前端代码 → 按审美指南生成生产级代码
  Step 6 → 交付前检查 → checklist 验证
```

---

## Phase 1: 设计智能

### Step 1: 分析需求

从用户请求中提取关键信息：
- **产品类型**：娱乐（社交/视频/音乐/游戏）、工具（扫描/编辑/转换）、生产力（任务管理/笔记/日历）或混合型
- **目标受众**：C 端消费者；考虑年龄段、使用场景（通勤/休闲/工作）
- **风格关键词**：playful、vibrant、minimal、dark mode、content-first、immersive 等
- **技术栈**：确认项目的框架（React / Vue / React Native / 等）

### Step 2: 生成设计系统（必选）

始终以 `--design-system` 开头获取完整的设计建议：

```bash
python3 .claude/skills/os-ui/scripts/search.py "<产品类型> <行业> <关键词>" --design-system [-p "项目名"]
```

该命令：
1. 并行搜索多个领域（product, style, color, landing, typography）
2. 应用推理规则从 `ui-reasoning.csv` 中选取最佳匹配
3. 返回完整的设计系统：风格、配色、字体、效果
4. 包含要避免的反模式

**示例：**
```bash
python3 .claude/skills/os-ui/scripts/search.py "beauty spa wellness service" --design-system -p "Serenity Spa"
```

**持久化设计系统（跨会话）：**
```bash
python3 .claude/skills/os-ui/scripts/search.py "<query>" --design-system --persist -p "项目名"
```

创建 `design-system/MASTER.md`（全局真相源）+ `design-system/pages/`（页面级覆盖）。

**分层检索：**
1. 构建特定页面时，先检查 `design-system/pages/<page>.md`
2. 如果文件存在，其规则覆盖 MASTER.md
3. 如果不存在，使用 MASTER.md

### Step 3: 补充领域搜索（按需）

获取设计系统后，可深入某个领域获取更多细节：

```bash
python3 .claude/skills/os-ui/scripts/search.py "<关键词>" --domain <domain> [-n <结果数>]
```

| 需要 | Domain | 示例 |
|------|--------|------|
| 产品类型模式 | `product` | `--domain product "entertainment social"` |
| 更多风格选项 | `style` | `--domain style "glassmorphism dark"` |
| 调色板 | `color` | `--domain color "entertainment vibrant"` |
| 字体搭配 | `typography` | `--domain typography "playful modern"` |
| 图表推荐 | `chart` | `--domain chart "real-time dashboard"` |
| UX 最佳实践 | `ux` | `--domain ux "animation accessibility"` |
| 字体查询 | `google-fonts` | `--domain google-fonts "sans serif popular"` |
| 着陆页结构 | `landing` | `--domain landing "hero social-proof"` |
| React 性能 | `react` | `--domain react "rerender memo list"` |
| Web 指南 | `web` | `--domain web "accessibilityLabel touch safe-areas"` |
| 提示词/CSS | `prompt` | `--domain prompt "minimalism"` |

**技术栈指南：**
```bash
python3 .claude/skills/os-ui/scripts/search.py "<关键词>" --stack <stack>
```

可用栈：`react`, `nextjs`, `vue`, `svelte`, `astro`, `swiftui`, `react-native`, `flutter`, `nuxtjs`, `nuxt-ui`, `html-tailwind`, `shadcn`, `jetpack-compose`, `threejs`

---

## Phase 2: 创意实现

### Step 4: 确定审美方向（必选）

编码前，理解上下文并选择一个**大胆的审美方向**：

- **目的**：这个界面解决什么问题？谁在使用它？
- **基调**：选择一个极端方向——极致简约、极繁主义、复古未来、有机自然、奢华精致、俏皮玩具、杂志编辑、粗野主义、装饰几何、柔和粉彩、工业实用等
- **约束**：技术要求（框架、性能、可访问性）
- **差异化**：什么让这个设计**令人难忘**？用户会记住哪一个瞬间？

**关键：** 选择清晰的概念方向并精准执行。大胆的极繁主义和精致的极简主义都可以——关键在于有意图，而非强度。

### Step 5: 实现前端代码

按审美方向实现生产级代码（HTML/CSS/JS、React、Vue 等），要求：
- 生产级且功能完整
- 视觉上引人注目且令人难忘
- 有凝聚力的审美观点
- 每个细节都精心打磨

### 前端审美指南

#### 字体排印
- 选择美观、独特、有趣的字体。避免 Arial、Inter 等通用字体；选择能提升审美的特色字体
- 将独特的展示字体与精致的正文字体配对
- 建立一致的字体等级体系（如 12 14 16 18 24 32）

#### 色彩与主题
- 承诺统一的审美。使用 CSS 变量保证一致性
- 主色加锐利强调色优于均衡分布的中性调色板
- 定义语义化颜色 token（primary, secondary, error, surface），不在组件中用硬编码色值

#### 动效
- 微交互使用 150-300ms，复杂转场 ≤400ms
- 优先使用 CSS-only 方案（HTML 项目）。React 项目使用 Motion 库
- 聚焦高冲击时刻：一个有交错显示的页面加载（animation-delay）比分散的微交互更令人愉悦
- 使用 scroll-triggering 和令人惊喜的 hover 状态
- 仅使用 transform/opacity 做动画；避免改变 width/height/top/left

#### 空间构成
- 出人意料的布局：不对称、重叠、对角线流动、打破网格的元素
- 慷慨的留白或受控的密度
- 使用 4/8pt 递增间距系统

#### 背景与视觉细节
- 营造氛围和深度，而不是只使用纯色
- 添加符合整体审美的上下文效果和纹理
- 创意形式：渐变网格、噪点纹理、几何图案、分层透明度、戏剧性阴影、装饰边框、自定义光标、颗粒叠加

#### 严禁使用的通用 AI 审美
- 过度使用的字体家族（Inter、Roboto、Arial、系统字体）
- 老套的配色方案（特别是紫色渐变配白色背景）
- 可预测的布局和组件模式
- 缺乏上下文特定性格的千篇一律的设计

**始终：** 创造性地诠释，做出真正为上下文设计的选择。没有两个设计应该相同。在亮/暗主题、不同字体、不同审美间切换。切勿收敛到常见选择。

**匹配实现复杂度与审美愿景：** 极繁主义设计需要精心制作的代码和丰富的动效。极简主义设计需要克制、精准和对间距字体细节的专注。

---

## 快速参考：UX 优先级规则

按优先级 1→10 依次检查。每个类别对应 `--domain` 搜索的领域。

| 优先级 | 类别 | 影响 | Domain | 关键检查项 |
|--------|------|------|--------|-----------|
| 1 | 可访问性 | 关键 | `ux` | 对比度 4.5:1、Alt 文本、键盘导航、Aria-labels |
| 2 | 触摸与交互 | 关键 | `ux` | 最小尺寸 44×44px、8px+ 间距、加载反馈 |
| 3 | 性能 | 高 | `ux` | WebP/AVIF、懒加载、预留空间（CLS < 0.1） |
| 4 | 风格选择 | 高 | `style`, `product` | 匹配产品类型、一致性、SVG 图标 |
| 5 | 布局与响应式 | 高 | `ux` | 移动端优先断点、无水平滚动 |
| 6 | 字体与配色 | 中 | `typography`, `color` | 基础 16px、行高 1.5、语义色值 token |
| 7 | 动效 | 中 | `ux` | 时长 150-300ms、动效传达含义、空间连续性 |
| 8 | 表单与反馈 | 中 | `ux` | 可见标签、字段旁错误、帮助文本 |
| 9 | 导航模式 | 高 | `ux` | 可预测返回、底部导航 ≤5、深链接 |
| 10 | 图表与数据 | 低 | `chart` | 图例、工具提示、无障碍颜色 |

各优先级详细规则（如果需要深入某个领域，始终通过 `--domain <domain>` 搜索）：

### 1. 可访问性（关键）
- 颜色对比度 ≥4.5:1（正常文本）/ 3:1（大文本）
- 交互元素可见焦点环（2-4px）
- 有意义的图片 Alt 文本
- 纯图标按钮的 aria-label
- Tab 顺序匹配视觉顺序
- 配合 `<label for>` 的表单标签
- 跳转到主要内容的跳过链接
- 顺序 h1→h6 标题层级，不跳级
- 不止用颜色传达信息（添加图标/文本）
- 支持系统文本缩放
- 尊重 prefers-reduced-motion

### 2. 触摸与交互（关键）
- 触摸目标最小 44×44pt（iOS）/ 48×48dp（Android）
- 触摸目标间至少 8px/8dp 间隙
- 主要交互使用 click/tap，不依赖 hover 单独操作
- 异步操作时禁用按钮并显示 spinner
- 清晰错误信息放在问题字段旁
- 可点击元素添加 cursor-pointer
- 避免主要内容区的水平滑动
- 触摸操作使用 touch-action: manipulation 消除 300ms 延迟

### 3. 性能（高）
- 使用 WebP/AVIF、响应式图片（srcset/sizes）、懒加载
- 声明图片 width/height 或 aspect-ratio 防止布局偏移
- 使用 font-display: swap/optional
- 优先加载首屏 CSS
- 按路由/特性拆分代码
- 第三方脚本 async/defer
- 避免频繁布局读写
- 为异步内容预留空间
- 50+ 项的列表虚拟化
- 骨架屏 / shimmer 代替长时间 spinner

### 4. 风格选择（高）
- 风格匹配产品类型
- 所有页面风格一致
- 使用 SVG 图标（Heroicons / Lucide），不用 emoji
- 根据产品/行业选择配色
- 阴影、模糊、圆角与选定风格对齐（glass / flat / clay）
- 一致的 elevation/阴影层级
- 亮/暗模式一起设计
- 整个产品使用同一图标集的视觉语言

### 5. 布局与响应式（高）
- viewport meta: width=device-width initial-scale=1（不禁用缩放）
- 移动端优先，再放大到平板和桌面
- 系统化的断点（如 375 / 768 / 1024 / 1440）
- 移动端正文字体最小 16px
- 行长度：移动端 35-60 字符，桌面端 60-75 字符
- 无水平滚动
- 使用 4pt/8dp 递增间距系统
- 一致的桌面端 max-width

### 6-10. 中低优先级
使用 `--domain` 搜索详细规则：
- `--domain ux "animation accessibility z-index loading"` — UX 最佳实践
- `--domain typography "elegant luxury"` — 字体搭配
- `--domain color "saas fintech"` — 配色方案
- `--domain chart "real-time dashboard"` — 图表
- `--domain ux "form validation error"` — 表单与反馈
- `--domain ux "navigation tab bar"` — 导航模式

---

## 常用 UI 规则

### 图标与视觉元素
| 规则 | 标准 | 避免 |
|------|------|------|
| 不用 emoji 做图标 | 使用矢量图标（Lucide、Heroicons） | 用 emoji 做导航/设置/系统控件 |
| 仅使用矢量素材 | SVG 或平台矢量图标 | PNG 光栅图标 |
| 稳定的交互状态 | 颜色/透明度/高度变化，不改变布局 | 布局移动导致周围内容抖动 |
| 一致的图标尺寸 | 尺寸定义为设计 token（icon-sm/md/lg） | 随机混用 20pt/24pt/28pt |
| 描边一致性 | 同一层使用一致描边宽度 | 粗细混用 |
| 实心/线框统一 | 每个层级使用一种风格 | 同一层级混用两种风格 |

### 亮/暗模式对比
| 规则 | 该做 | 不该做 |
|------|------|--------|
| 浅色模式表面可读性 | 卡片/表面与背景有足够对比 | 过于透明的表面 |
| 文本对比 | 正文对比度 ≥4.5:1 | 低对比度灰色正文 |
| 暗色模式文本对比 | 主文本 ≥4.5:1，次文本 ≥3:1 | 暗色模式文本融入背景 |
| token 驱动主题 | 使用语义化颜色 token 映射 | 每屏硬编码色值 |
| Modal 遮罩 | 40-60% 黑色确保前景可读 | 遮罩过弱导致背景干扰 |

### 布局与间距
| 规则 | 该做 | 不该做 |
|------|------|--------|
| 安全区域 | 所有固定元素尊重安全区域 | 内容放在刘海/状态栏/手势区下 |
| 系统栏间距 | 为状态栏/导航栏/手势 Home 预留 | 可触控内容与系统 UI 碰撞 |
| 8dp 间距韵律 | 使用一致的 4/8dp 间距系统 | 随机间距增量 |
| 可读文本行宽 | 大屏不铺满（避免边缘到边缘段落） | 全宽长文本 |
| 滚动与固定元素 | 列表添加内容内边距不遮挡 | 滚动内容被固定栏挡住 |

---

## 常见问题处理

| 问题 | 处理方法 |
|------|---------|
| 不确定风格/颜色 | 用不同关键词重新运行 `--design-system` |
| 暗色模式对比度问题 | `--domain ux "color dark mode contrast"` |
| 动效不自然 | `--domain ux "spring physics easing"` |
| 表单 UX 差 | `--domain ux "inline validation error clarity"` |
| 导航混乱 | `--domain ux "navigation hierarchy bottom nav"` |
| 小屏布局崩 | `--domain ux "mobile first responsive"` |
| 性能卡顿 | `--domain react "virtualize list memo"` |

---

## 交付前检查清单

### 视觉质量
- [ ] 没有使用 emoji 作为图标（使用 SVG）
- [ ] 所有图标来自一致的图标家族和风格
- [ ] 按压态不改变布局边界或导致抖动
- [ ] 语义化主题 token 一致使用（无临时色值）
- [ ] 暗色模式对比度独立验证

### 交互
- [ ] 所有可点击元素提供明确的按压反馈（ripple/opacity/elevation）
- [ ] 触摸目标满足最小尺寸（≥44×44pt iOS，≥48×48dp Android）
- [ ] 微交互时长 150-300ms，使用平台感缓动
- [ ] 禁用状态视觉清晰且不可交互
- [ ] 屏幕阅读器焦点顺序匹配视觉顺序

### 可访问性
- [ ] 所有有意义的图片/图标有无障碍标签
- [ ] 表单字段有标签、提示和清晰的错误信息
- [ ] 颜色不是唯一指示器
- [ ] 支持 reduced-motion 和动态文本大小

### 布局
- [ ] 在 375px（小手机）和横屏模式下测试
- [ ] 安全区域对固定元素生效
- [ ] 滚动内容不被固定栏遮挡
- [ ] 4/8dp 间距韵律一致
- [ ] 大屏文本行宽可读

### 在 os-workflow 中的使用

当判定表匹配到 UI 相关行时，Build 阶段调用本 skill 替代手动编写 UI 代码。`os-design` 阶段应调用本 skill 的 Phase 1（设计智能）获取设计参考。
