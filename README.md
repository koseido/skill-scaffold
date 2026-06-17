# skill-scaffold

一个轻量级的 AI Skill 创建与管理脚手架，用于帮助用户按最佳实践创建、安装、组织、检索和校验本地 AI Skills。

它的核心目标是：

> 当本地 Skills 越来越多时，让 Skills 依然好找、好用、好维护、可控触发。

---

## 项目背景

随着 Claude Code、Codex、VSCode AI IDE 等工具的使用变多，越来越多用户会开始在本地安装和沉淀大量 Skills。

一开始，几个 Skill 很容易管理：

```text
code-review
prd-review
concept-explain
```

但当 Skill 数量变成几十个之后，问题会迅速出现：

```text
learn-roadmap
learn-concept-explain
pm-prd-review
pm-feature-design
ux-prototype-review
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
doc-architecture-update
...
```

这时真正的痛点不再是“有没有 Skill”，而是：

1. 怎么快速找到应该用哪个 Skill
2. 怎么让 AI 准确判断什么时候该用某个 Skill
3. 怎么避免多个 Skill 职责重叠
4. 怎么避免高风险 Skill 被自动误触发
5. 怎么区分全局 Skill 和项目级 Skill
6. 怎么让 Skill 的名称、描述、目录结构保持一致
7. 怎么让 Codex、Claude Code、VSCode AI IDE 都能按同一套规范创建 Skill
8. 怎么在团队或开源场景下让别人看得懂、装得上、用得对

如果没有规范，Skills 很容易变成一堆难以维护的本地提示词文件：

```text
helper
review
fix
coding
my-skill
test-agent
workflow
```

这些名字看起来都能用，但真正使用时会遇到几个问题：

- 人找不到合适的 Skill
- AI 不知道该不该触发
- `description` 太泛导致误触发
- 高风险 Skill 没有限制
- `SKILL.md` 越写越长
- 没有索引文件
- 没有统一校验规则
- 团队成员各写各的，难以复用

因此，Skills 的管理和使用其实需要一套最佳实践。

`skill-scaffold` 就是为了解决这个问题。

它不是为了替你安装更多 Skill，而是为了让你已有和未来创建的 Skills 更规范、更容易检索、更容易精准使用。

---

## 重要说明：不会自动修改已有 Skills

`skill-scaffold` 不会自动接管、修改或重构你已经安装的 Skills。

它的主要作用是：

1. 在**新建 Skill** 时，按照最佳实践生成标准目录结构和 `SKILL.md`
2. 在**安装 Skill** 时，帮助你选择正确的安装位置、命名方式和风险等级
3. 在**安装 GitHub 上已有 Skill** 时，帮助你先审查、再规范化安装、再登记索引、再校验
4. 在**管理 Skill** 时，帮助你维护 `SKILLS_INDEX.md`
5. 在**校验 Skill** 时，检查命名、description、目录结构、风险控制和脚本安全性
6. 在**整理已有 Skills** 时，提供改造建议，但不会自动修改，除非你明确确认

也就是说，`skill-scaffold` 更像是一个 **Skill 创建与管理规范助手**，而不是一个自动迁移工具。

对于已有 Skills：

```text
不会自动生效
不会自动重命名
不会自动改 description
不会自动移动目录
不会自动增加 disable-model-invocation
不会自动删除或覆盖文件
```

如果你希望整理已有 Skills，可以手动调用：

```text
/skill-scaffold

请检查我当前项目 .claude/skills 下已有的 Skills，
只输出问题和优化建议，不要修改文件。
```

然后再根据建议逐步确认修改。

对于新创建或新安装的 Skills，`skill-scaffold` 会按最佳实践帮助你规范化处理：

```text
命名规范
description 写法
global / project 作用域
风险等级
是否禁用自动触发
references / templates / examples 目录
SKILLS_INDEX.md 索引
validate-skill.sh 校验
```

更准确地说：

> `skill-scaffold` 不会让已有 Skills 自动变规范；它是在后续新建、安装、整理和校验 Skills 时，使用一套追加的最佳实践管理方式，帮助你把 Skills 管理得更清晰、更安全、更容易检索和使用。

---

## 这个项目解决什么问题

`skill-scaffold` 解决的是 **Skills 数量变多后的管理问题**。

它不仅适用于自己创建新 Skill，也适用于从 GitHub 安装已有 Skill 时的审查、规范化、索引登记和安全校验。

它重点解决以下问题。

### 1. Skill 如何命名

让 Skill 名称具备可检索性和可定位性。

推荐格式：

```text
<domain>-<action>-<object>
```

例如：

```text
learn-concept-explain
pm-prd-review
code-safe-feature
db-migration-review
ops-release-check
```

而不是：

```text
helper
review
fix
agent
workflow
```

### 2. Skill 如何描述

让 `description` 不只是介绍，而是帮助 AI 判断：

- 这个 Skill 做什么
- 什么时候应该用
- 什么时候不应该用
- 哪些关键词应该触发它

推荐写法：

```yaml
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, or workflows. Do not use for simple copywriting or one-line style changes. Keywords: new feature, API change, workflow change, before coding.
```

### 3. Skill 如何分层管理

区分：

```text
全局 Skill
项目级 Skill
实验 Skill
禁用 Skill
归档 Skill
```

避免所有 Skill 都堆在一个目录里，后续无法定位。

### 4. Skill 如何控制风险

对于代码、数据库、部署、发布等高风险场景，默认建议：

```yaml
disable-model-invocation: true
```

也就是只允许用户手动调用，避免 AI 自动误触发。

例如：

```text
/code-safe-feature
/db-migration-review
/ops-release-check
```

### 5. Skill 如何保持可维护

推荐每个 Skill 使用统一结构：

```text
<skill-name>/
├── SKILL.md
├── references/
├── templates/
└── examples/
```

让 `SKILL.md` 保持简洁，详细规则放到 `references/`，输出格式放到 `templates/`，触发示例放到 `examples/`。

### 6. Skill 如何被检索和使用

通过：

```text
SKILLS_INDEX.md
```

统一记录：

```md
| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|
```

这样人可以快速查找，AI IDE 也可以读取这个索引辅助判断。

---

## 项目定位

`skill-scaffold` 是一个 **Skill 创建、安装、组织和校验的轻量级脚手架**。

它的作用不是直接替代某个具体 Skill，而是帮助你创建和维护更多高质量 Skills。

你可以把它理解为：

```text
skill-scaffold = 创建 Skill 的 Skill + Skill 管理最佳实践 + Skill 校验规则
```

它适合：

- 个人用户管理本地大量 Skills
- 产品经理沉淀 AI 工作流
- 开发者管理 AI 编码流程
- 团队统一 AI IDE 使用规范
- 开源项目提供标准 Skill 模板
- Codex / Claude Code / VSCode AI IDE 共享同一套 Skill 创建规范
- 从 GitHub 安装第三方 Skills 前做审查和规范化

---

## 核心目标

`skill-scaffold` 希望做到：

1. **让 Skill 好找**  
   通过命名规范和索引管理提升检索效率。

2. **让 Skill 好用**  
   通过清晰的 description 和触发示例提升使用准确性。

3. **让 Skill 好维护**  
   通过标准目录结构、模板和校验规则减少后期混乱。

4. **让 Skill 更安全**  
   通过风险等级和自动触发控制避免高风险误用。

5. **让 Skill 更适合团队协作**  
   通过统一规范，让不同人创建的 Skill 保持一致。

6. **让不同 AI IDE 都能理解**  
   通过 `docs/SKILL_SPEC.md`、`AGENTS.md`、示例和模板，让 Codex、Claude Code、VSCode AI IDE 都能按同一套规则工作。

---

## Skill 是什么

在这个项目里，Skill 可以理解为：

```text
可复用工作流 + 元信息 + 操作说明 + 可选参考资料 + 可选模板 + 可选脚本
```

一个最小 Skill 结构是：

```text
<skill-name>/
└── SKILL.md
```

一个推荐 Skill 结构是：

```text
<skill-name>/
├── SKILL.md
├── references/
│   └── README.md
├── templates/
│   └── output-template.md
└── examples/
    └── trigger-examples.md
```

如果确实需要确定性命令，也可以增加：

```text
scripts/
```

但不建议默认创建脚本。

---

## 安装 Skill 的本质

安装 Skill 不是安装传统软件包。

它更像是：

```text
把一个符合规范的工作流目录复制到 AI 工具可以发现的位置
```

通常包括：

1. 创建标准 Skill 目录
2. 放入 `SKILL.md`
3. 按需放入 `references/`、`templates/`、`examples/`、`scripts/`
4. 放到全局或项目级 Skill 目录
5. 更新 `SKILLS_INDEX.md`
6. 校验命名、描述、风险等级和脚本安全性

---

## 项目结构

```text
skill-scaffold/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── .gitignore
├── skills/
│   └── skill-scaffold/
│       ├── SKILL.md
│       ├── references/
│       │   └── skill-best-practices.md
│       ├── templates/
│       │   ├── SKILL.template.md
│       │   └── output-template.md
│       └── examples/
│           └── trigger-examples.md
├── scripts/
│   ├── install-skill.sh
│   └── validate-skill.sh
├── docs/
│   ├── SKILL_SPEC.md
│   ├── INSTALLATION.md
│   ├── USAGE_WITH_CLAUDE_CODE.md
│   ├── USAGE_WITH_CODEX.md
│   └── USAGE_WITH_VSCODE_AI_IDE.md
└── examples/
    ├── code-safe-feature/
    │   └── SKILL.md
    ├── pm-prd-review/
    │   └── SKILL.md
    └── learn-concept-explain/
        └── SKILL.md
```

---

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/yourname/skill-scaffold.git
cd skill-scaffold
```

请将 `yourname` 替换为你的 GitHub 用户名或组织名。

### 2. 安装 skill-scaffold

全局安装：

```bash
chmod +x scripts/install-skill.sh
./scripts/install-skill.sh --scope global
```

默认会安装到：

```text
~/.claude/skills/skill-scaffold/
```

项目级安装：

```bash
./scripts/install-skill.sh --scope project --target /path/to/your-project
```

会安装到：

```text
/path/to/your-project/.claude/skills/skill-scaffold/
```

### 3. 使用 skill-scaffold

在 Claude Code 中可以这样使用：

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，先输出创建方案。
```

确认方案后：

```text
确认，请按方案创建文件，并更新 .claude/SKILLS_INDEX.md。
```

---

## 手动安装

如果不想使用脚本，也可以手动复制：

```bash
mkdir -p ~/.claude/skills
cp -R skills/skill-scaffold ~/.claude/skills/
```

安装后目录应为：

```text
~/.claude/skills/skill-scaffold/
├── SKILL.md
├── references/
├── templates/
└── examples/
```

---

## 安装 GitHub 上已有的 Skills

除了自己创建 Skill，用户也可能从 GitHub 上安装别人已经开源的 Skills。

这种场景更需要规范，因为第三方 Skill 可能存在：

- 命名不符合你的本地规范
- `description` 太宽泛，容易误触发
- 高风险 Skill 没有禁用自动触发
- `SKILL.md` 内容过长或结构混乱
- 包含不必要的 `scripts/`
- 脚本中存在危险命令
- 包含私有路径、环境变量、Token 或上传逻辑
- 不适合直接放入全局 Skills

因此，安装 GitHub 上已有 Skills 时，推荐使用 **“先审查、再安装、再校验”** 的流程。

### 推荐流程

```text
clone GitHub 仓库
↓
检查目录结构
↓
阅读 SKILL.md
↓
检查 references / templates / examples / scripts
↓
判断安装到 global 还是 project
↓
必要时重命名或调整 description
↓
复制到目标 skills 目录
↓
更新 SKILLS_INDEX.md
↓
运行 validate-skill.sh
↓
真实任务中测试
```

### 不推荐的做法

不要直接执行不了解的远程安装命令，例如：

```bash
curl https://example.com/install.sh | bash
```

也不要在没有审查的情况下直接把整个仓库复制到：

```text
~/.claude/skills/
```

第三方 Skill 应该先放到临时目录或实验目录中检查。

推荐：

```text
~/.claude/skills-lab/
```

确认安全和适用后，再移动到正式目录：

```text
~/.claude/skills/
```

### 从 GitHub 手动安装单个 Skill

假设 GitHub 仓库结构是：

```text
some-skills-repo/
└── skills/
    └── code-review/
        ├── SKILL.md
        ├── references/
        └── templates/
```

可以先 clone：

```bash
git clone https://github.com/example/some-skills-repo.git
cd some-skills-repo
```

先检查文件：

```bash
find skills/code-review -maxdepth 3 -type f
cat skills/code-review/SKILL.md
```

重点检查：

```text
name
description
disable-model-invocation
scripts/
references/
templates/
examples/
```

如果确认安全，再安装到全局：

```bash
mkdir -p ~/.claude/skills
cp -R skills/code-review ~/.claude/skills/
```

或者安装到当前项目：

```bash
mkdir -p .claude/skills
cp -R skills/code-review .claude/skills/
```

安装后运行校验：

```bash
./scripts/validate-skill.sh ~/.claude/skills
```

或：

```bash
./scripts/validate-skill.sh .claude/skills
```

### 从 GitHub 安装前的检查清单

安装第三方 Skill 前，至少检查以下内容：

```text
1. Skill 名称是否清晰
2. 是否使用 lowercase kebab-case
3. description 是否具体
4. description 是否说明 when to use / when not to use
5. 是否属于高风险 Skill
6. 高风险 Skill 是否包含 disable-model-invocation: true
7. SKILL.md 是否结构清晰
8. 是否存在 scripts/
9. scripts/ 是否包含危险命令
10. 是否读取 .env、~/.ssh 或其他敏感文件
11. 是否执行 curl、wget、ssh、scp、git push 等命令
12. 是否上传文件或访问外部服务
13. 是否包含私有路径、Token、密钥或公司内部信息
14. 是否适合全局安装，还是只适合项目级安装
```

### 危险命令检查

如果第三方 Skill 包含 `scripts/`，需要重点检查是否包含：

```text
rm -rf
curl
wget
ssh
scp
git push
git reset --hard
sudo
chmod 777
.env
~/.ssh
id_rsa
id_ed25519
upload
deploy
production
```

如果存在这些内容，不要直接安装到正式目录。

可以先放到：

```text
~/.claude/skills-lab/
```

然后人工确认是否需要修改或禁用。

### 什么时候安装到全局

适合安装到全局：

```text
~/.claude/skills/
```

的第三方 Skill 通常是低风险、通用型 Skill，例如：

```text
learn-concept-explain
writing-polish
prompt-refine
summary-structure
```

这些 Skill 通常只做解释、总结、写作或结构化输出。

### 什么时候安装到项目

适合安装到项目：

```text
.claude/skills/
```

的第三方 Skill 通常和代码、数据库、发布、项目结构有关，例如：

```text
code-safe-feature
code-review
db-migration-review
ops-release-check
doc-architecture-update
```

这些 Skill 可能依赖项目上下文，不建议直接全局安装。

### 安装后如何规范化

如果 GitHub 上的 Skill 有价值，但不完全符合本项目规范，可以用 `skill-scaffold` 辅助整理。

示例：

```text
/skill-scaffold

我从 GitHub 安装了一个 Skill，路径是：

.claude/skills/code-review/

请帮我检查它是否符合最佳实践。
只输出问题和优化建议，不要修改文件。
```

如果确认要修改：

```text
确认，请帮我按最佳实践优化这个 Skill：
1. 保留原始用途
2. 优化 name 和 description
3. 补充 Best for / Not for / Required inputs / Workflow / Output format / Safety rules
4. 如果是高风险 Skill，增加 disable-model-invocation: true
5. 更新 .claude/SKILLS_INDEX.md
```

### 推荐的 GitHub Skill 安装策略

对于 GitHub 上已有 Skills，建议分三步：

```text
第一步：临时安装
放到 skills-lab/ 或项目临时目录中检查。

第二步：规范化
用 skill-scaffold 检查命名、description、风险等级、目录结构和脚本安全。

第三步：正式安装
确认安全后，再复制到 ~/.claude/skills/ 或 .claude/skills/。
```

### 用 install-skill.sh 安装 GitHub Skill

如果已经 clone 了第三方仓库，并且其中某个 Skill 目录符合结构，可以使用：

```bash
./scripts/install-skill.sh \
  --source /path/to/some-skills-repo/skills/code-review \
  --scope global
```

安装到项目：

```bash
./scripts/install-skill.sh \
  --source /path/to/some-skills-repo/skills/code-review \
  --scope project \
  --target /path/to/your-project
```

如果目标位置已经存在同名 Skill，建议先不要覆盖。

确实要覆盖时，再使用：

```bash
./scripts/install-skill.sh \
  --source /path/to/some-skills-repo/skills/code-review \
  --scope project \
  --target /path/to/your-project \
  --force
```

`--force` 应该先备份旧目录，再覆盖。

### 对 GitHub Skill 的态度

`skill-scaffold` 不反对安装 GitHub 上已有的 Skills。

但它建议：

> 不要直接信任第三方 Skill。  
> 先审查，再规范化，再安装，再校验。

这样才能保证本地 Skills 越装越多时，仍然保持清晰、安全和可维护。

---

## 校验 Skill

使用校验脚本：

```bash
chmod +x scripts/validate-skill.sh
./scripts/validate-skill.sh ~/.claude/skills
```

校验项目级 Skills：

```bash
./scripts/validate-skill.sh .claude/skills
```

校验内容包括：

- Skill 目录是否存在
- `SKILL.md` 是否存在
- 是否包含 `name`
- 是否包含 `description`
- 命名是否为 lowercase kebab-case
- 描述是否具体
- 是否包含推荐章节
- 高风险 Skill 是否禁用自动触发
- 是否存在不必要脚本
- 脚本中是否包含危险命令

---

## 核心最佳实践

### 1. 区分全局 Skill 和项目级 Skill

全局 Skill：

```text
~/.claude/skills/
```

适合：

- AI 学习
- 概念解释
- 提示词优化
- 通用写作
- Skill 创建脚手架

项目级 Skill：

```text
.claude/skills/
```

适合：

- 代码安全开发
- Bug 修复流程
- 数据库迁移评审
- 发布前检查
- 项目架构文档更新

### 2. 使用清晰命名

推荐格式：

```text
<domain>-<action>-<object>
```

示例：

```text
learn-concept-explain
pm-prd-review
ux-prototype-review
code-safe-feature
code-bug-fix
db-migration-review
ops-release-check
doc-architecture-update
```

避免：

```text
review
helper
fix
assistant
agent
workflow
```

### 3. description 要为触发服务

不要写：

```yaml
description: Helps with code.
```

推荐写：

```yaml
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, or workflows. Do not use for simple copywriting or one-line style changes. Keywords: new feature, API change, workflow change, before coding.
```

### 4. 高风险 Skill 禁用自动触发

涉及代码、数据库、发布、部署、脚本执行等高风险场景时，建议加：

```yaml
disable-model-invocation: true
```

例如：

```text
code-safe-feature
db-migration-review
ops-release-check
```

这些 Skill 建议手动调用：

```text
/code-safe-feature
/db-migration-review
/ops-release-check
```

### 5. 保持 SKILL.md 简洁

`SKILL.md` 应该是入口文件，不是知识库。

详细规则放：

```text
references/
```

输出格式放：

```text
templates/
```

触发示例放：

```text
examples/
```

确定性命令才放：

```text
scripts/
```

---

## 示例 Skills

本仓库提供 3 个示例 Skill。

### code-safe-feature

用于新增或修改功能前做安全变更分析。

位置：

```text
examples/code-safe-feature/SKILL.md
```

适合：

- 新增功能
- 修改接口
- 修改页面行为
- 修改业务流程
- 影响多个模块的代码变更

### pm-prd-review

用于评审产品需求文档。

位置：

```text
examples/pm-prd-review/SKILL.md
```

适合：

- PRD 评审
- 需求完整性检查
- 用户场景补充
- 验收标准检查
- 实现风险识别

### learn-concept-explain

用于结构化解释 AI、产品或技术概念。

位置：

```text
examples/learn-concept-explain/SKILL.md
```

适合：

- 解释 LLM、RAG、Agent、MCP
- AI 产品经理学习
- 技术概念入门
- 对比不同技术方案

---

## 与 Claude Code 一起使用

安装后，在 Claude Code 中运行：

```text
/skill-scaffold
```

示例：

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: pm
- name: prd-review
- risk: medium
- purpose: 评审产品需求文档，检查目标、用户场景、业务流程、边界条件、验收标准和实现风险

先不要创建文件，先输出创建方案。
```

更多说明见：

```text
docs/USAGE_WITH_CLAUDE_CODE.md
```

---

## 与 Codex 一起使用

Codex 不一定原生识别 Claude 风格的 `/skill-name`，但可以读取文件规范。

推荐把规则写进：

```text
AGENTS.md
```

并让 Codex 读取：

```text
docs/SKILL_SPEC.md
```

示例提示词：

```text
请先读取 AGENTS.md 和 docs/SKILL_SPEC.md。

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，请先输出创建方案。
```

更多说明见：

```text
docs/USAGE_WITH_CODEX.md
```

---

## 与 VSCode AI IDE 一起使用

对于 Cursor、Cline、Continue、GitHub Copilot Chat 等工具，可以把 `docs/SKILL_SPEC.md` 作为项目规范文件，让 AI 按规范创建 Skill 文件。

推荐流程：

```text
读取 docs/SKILL_SPEC.md
↓
先输出 Skill 创建方案
↓
确认后创建文件
↓
更新 SKILLS_INDEX.md
↓
运行校验
```

更多说明见：

```text
docs/USAGE_WITH_VSCODE_AI_IDE.md
```

---

## 推荐工作流

```text
安装 skill-scaffold
↓
用 skill-scaffold 创建新 Skill
↓
先输出方案，不直接创建文件
↓
确认后生成 SKILL.md 和辅助目录
↓
更新 SKILLS_INDEX.md
↓
运行 validate-skill.sh
↓
在真实任务中测试 Skill
↓
根据使用反馈迭代
```

---

## 安全原则

本项目默认遵守以下安全原则：

- 不默认创建脚本
- 不执行部署命令
- 不执行数据库迁移
- 不读取 `.env`
- 不读取 SSH 密钥
- 不上传文件
- 不删除用户文件
- 不访问生产系统
- 高风险 Skill 默认要求手动调用
- 脚本只做静态检查或文件复制
- 安装 GitHub 第三方 Skills 前必须先审查

如果你安装第三方 Skill，请先检查：

```text
SKILL.md
references/
templates/
examples/
scripts/
```

重点关注脚本中是否包含：

```text
rm -rf
curl
wget
ssh
scp
git push
git reset --hard
sudo
chmod 777
.env
~/.ssh
```

---

## 常见问题

### 安装 skill-scaffold 后，已有 Skills 会自动变规范吗？

不会。

`skill-scaffold` 不会自动修改你已有的 Skills。它主要在新建、安装、整理和校验 Skills 时提供规范化流程。

### 能不能用它检查已有 Skills？

可以，但建议先只让它输出建议：

```text
/skill-scaffold

请检查我当前项目 .claude/skills 下已有的 Skills，
只输出问题和优化建议，不要修改文件。
```

确认后再逐步改造。

### 能不能用它安装 GitHub 上已有的 Skills？

可以。

但推荐流程是：

```text
先 clone
再审查 SKILL.md 和 scripts/
再判断 global / project
再安装
再校验
```

不要直接执行未知的远程安装脚本。

### 是否一定要用 Claude Code？

不一定。

Claude Code 可以直接通过 `/skill-scaffold` 使用。Codex 和 VSCode AI IDE 可以通过读取 `docs/SKILL_SPEC.md` 和 `skills/skill-scaffold/SKILL.md` 来按同一套规范创建 Skill。

### 是否必须创建 scripts/？

不是。

大多数 Skill 不需要脚本。只有当某个动作是确定性的、可重复的、比 AI 自由执行更安全时，才建议创建脚本。

### 高风险 Skill 为什么要手动调用？

因为代码、数据库、部署、发布等动作可能造成实际影响。高风险 Skill 使用手动调用可以降低误触发风险。

---

## 路线图

### v0.1.0

- 提供 `skill-scaffold` Skill
- 提供 Skill 最佳实践文档
- 提供标准 `SKILL.md` 模板
- 提供基础安装脚本
- 提供基础校验脚本
- 提供 3 个示例 Skill
- 覆盖 GitHub 第三方 Skill 安装审查流程

### v0.2.0

- 增强 `install-skill.sh`
- 增强 `validate-skill.sh`
- 支持自动生成 `SKILLS_INDEX.md`
- 增加更多 AI IDE 使用示例
- 增加更多示例 Skill

### v0.3.0

- 支持参数化创建 Skill
- 支持生命周期目录
- 支持 Skill 风险等级检查
- 支持批量校验

### v1.0.0

- 文档稳定
- 脚本稳定
- 示例丰富
- 社区贡献规范完善
- 适合团队使用

---

## 贡献指南

欢迎贡献：

- 新的示例 Skill
- 更好的 `SKILL.md` 模板
- 更完整的校验规则
- 更安全的安装脚本
- Codex / Claude Code / VSCode AI IDE 使用经验
- GitHub 第三方 Skill 安装与审查经验
- 文档改进

贡献前请阅读：

```text
CONTRIBUTING.md
```

贡献时请确保：

- 不包含密钥、Token、`.env`
- 不包含个人路径
- 不包含私有服务器信息
- 不包含公司内部不可公开内容
- 不添加危险脚本
- 示例尽量通用化

---

## 许可证

本项目建议使用 MIT License。

如果你 fork 或修改本项目，请保留原始许可证声明。

---

## 免责声明

`skill-scaffold` 是一个轻量级开源脚手架，用于帮助用户创建和管理本地 AI Skills。

它不会替你判断所有安全风险。

使用任何会修改代码、数据库、部署环境、生产系统或敏感文件的 Skill 前，请务必人工检查并确认。

从 GitHub 或其他第三方来源安装 Skills 前，也请先审查 `SKILL.md`、`scripts/` 和相关资源文件。

---

## 一句话总结

当你只有几个 Skills 时，靠记忆就够了。

当你有几十个 Skills 时，就需要一套规范。

`skill-scaffold` 的目的就是：

> 帮助用户在安装和使用大量 Skills 的情况下，仍然能够精准定位、正确触发、安全使用、持续维护。
