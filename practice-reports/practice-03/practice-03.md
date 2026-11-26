# 实践课 3：Pi Agent 源码获取、依赖安装与本地编译

- 姓名：瞿凯峰　学号：202430194023　姓名拼音：QuKaifeng
- 仓库：`D:\师大本科WORK\github\pi-hunnu-2026`（origin 为小组组织仓库）
- 分支：`course-main`　commit：`13cbf77df2396303013a41646bcfa77b4271ae56`
- 记录日期：2026-11-26
- 所有命令均在 Windows Terminal 的 PowerShell 5.1 中执行；截图为真实屏幕像素捕获，未合成界面。

## 任务一：检查开发工具

执行 `node --version`、`npm --version`、`git --version`，结果见 `screenshots/S1-env-versions.png`：

| 工具 | 实际版本 | 用途 |
|---|---|---|
| Node.js | `v24.21.0`（`D:\Node.js\node.exe`） | 运行 TypeScript 编译脚本、项目开发脚本 |
| npm | `11.19.0` | 安装依赖、执行 `npm run build` |
| Git | `git version 2.56.1.windows.1` | 下载与管理源码 |

根 `package.json` 声明 `"node": ">=22.19.0"`，当前 v24.21.0 满足要求，也与指导书建议的 Node.js 24 LTS 一致。npm 随 Node.js 安装，不单独记录“应等于某个版本”。

## 任务二：确认源码来源与版本

执行 `Get-Location`、`git remote -v`、`git branch --show-current`、`git rev-parse HEAD`、`git status --short`，截图 `screenshots/S2-git-info.png`。结果：当前目录 `D:\师大本科WORK\github\pi-hunnu-2026`；origin 指向 `https://github.com/hunnuOpenSourceSoftware2026Group001/pi-hunnu-2026.git`；分支 `course-main`；HEAD `13cbf77df2396303013a41646bcfa77b4271ae56`。网页端小组仓库默认分支 `main` 更新，和本地课程分支不同，报告以本地实测为准。

## 任务三：阅读配置，确认安装与编译依据

`screenshots/S3a-build-config.png` 与 `S3b-engine-config.png` 显示：

- `engines.node` 为 `>=22.19.0`，位于根 `package.json:68-70`。
- `scripts.build` 位于根 `package.json:16`，依次进入 `chord → tui → telemetry → ai → durable → agent → session-backends/sqlite-node → protocol → client → server → coding-agent`，每步执行该包的 `npm run build`，`&&` 表示前一步成功才继续。`build:offline` 顺序相同，只把 ai 的 `build` 换成 `build:offline`。

因此：Node 版本要求在根 `package.json`；`npm run build` 从根 `scripts.build` 读取命令，真正编译的是每个包自己的 `scripts.build` 与 `tsconfig.build.json`。仓库用 npm workspaces，依赖从根安装，没有给子包单独建锁文件。

## 任务四：安装项目依赖

在仓库根目录执行：

```powershell
npm install --ignore-scripts
```

为了让终端显示和日志留存一致，实际键入的是 `npm install --ignore-scripts 2>&1 | Tee-Object install-log.txt`，命令主体不变，只是把输出同步写入日志。结束输出见 `screenshots/S4a-install-finish.png`，退出码见 `screenshots/S4b-install-exitcode.png`：

- `added 336 packages, and audited 358 packages in 9m`
- `50 packages are looking for funding`
- `13 vulnerabilities (5 moderate, 7 high, 1 critical)`
- `$LASTEXITCODE` 为 `0`

安装日志原文见 `install-log.txt`。出现 `EBADENGINE`（`autoevals@0.3.0` 要求用 pnpm/pnpm>=10.27.0）和 `deprecated prebuild-install`、`deprecated node-domexception` 警告，但它们没有让命令失败，退出码为 0。`vulnerabilities` 是依赖审计结果，不等于安装失败；没有按提示执行 `npm audit fix --force`，以免改变课程使用的依赖版本。`--ignore-scripts` 只是跳过安装阶段自动生命周期脚本，不阻止后面主动 `npm run build`。

## 任务五：本地编译与构建产物验证

首次执行 `npm run build` 未成功，过程图 `screenshots/S5a-build-progress.png`，失败画面 `screenshots/D3-build-type-error.png`，日志 `build-log-first-fail.txt`。失败点在 `packages/ai`：

```text
src/providers/opencode-go.ts(14,3): error TS2322:
Type 'Model<"google-generative-ai"> ...' is not assignable to
type 'Model<"anthropic-messages" | "openai-completions" | "openai-responses">'
```

前置步骤 `generate-models` 联网拉取了最新模型目录（`check:model-data` 输出 `Generated model data is valid.`），新目录给 opencode-go 提供了 `api: "google-generative-ai"` 的模型，但 `opencode-go.ts` 的 Provider 类型只声明了三种 api，编译报错。这是本版本与实时模型数据之间的类型不匹配，不是 Node 版本问题，也不是网络下载失败。

修复方式参照同仓库同层的 `packages/ai/src/providers/opencode.ts`（它已经支持四种 api）：在 `opencode-go.ts` 中补 `googleGenerativeAIApi` 导入、把泛型联合类型加上 `"google-generative-ai"`、在 `api` 映射中加对应适配器。差异截图 `screenshots/D4-fix-diff.png`，可用 `git diff -- packages/ai/src/providers/opencode-go.ts` 复核。

重新执行 `npm run build`，成功日志 `build-log-success.txt`，结尾为：

```text
Built packages\coding-agent\dist\bundle (56 files, 8.1 MiB)
```

验证截图 `screenshots/S5c-build-finish.png`、`screenshots/S5d-build-verify.png`：

| 检查 | 结果 |
|---|---|
| `$LASTEXITCODE` | `0` |
| `Test-Path ./packages/coding-agent/dist/bundle/cli.js` | `True` |
| `node ./packages/coding-agent/dist/bundle/cli.js --version` | `0.86.1` |

只看到某个子包成功不能代表根构建成功；这里以根 build 返回码 0 和 CLI 产物版本号共同证明。以后若只改源码、模型数据仍有效，可用 `npm run build:offline` 复用已生成目录。

## 任务六：启动本地源码版本并完成一次会话

`screenshots/S6a-source-entry-version.png`：`./pi-test.bat --version` 输出 `0.86.1`。`S6d-entry-retry.png` 显示 `./pi-test.bat` 启动后的 Pi 界面（`pi v0.86.1`、`[Skills]`、`[Extensions]`、底部 `deepseek-flash • high`）。该脚本通过 `node_modules/.bin/tsx.cmd` 运行 `packages/coding-agent/src/cli.ts`，所以能证明运行的是本地源码，而不是第一次实践安装的全局 `pi`（全局版为 1.5.0）。本地源码版与全局版共用 `~/.pi/agent` 配置，因此不需要重新登录，这不表示运行了全局版本。

在同一会话输入：

```text
请用一句话说明源码和编译产物的区别。只回答问题，不修改文件。
```

模型真实回复（`screenshots/S6e-source-chat.png`）：

> 源码是开发者编写、可读的原始代码（如 .ts 文件）；编译产物是经过编译器或打包器转换生成、供机器执行的代码（如 .js 文件）。

## 遇到的困难与解决过程（重点）

1. **npm 走系统代理返回 502。** `npm ping` 显示 `npm error code E502 ... GET https://registry.npmjs.org/-/ping`，截图 `screenshots/D1-npm-proxy-fail.png`。处理：在当前 PowerShell 会话执行 `$env:HTTPS_PROXY=$null`、`$env:HTTP_PROXY=$null`，再次 `npm ping` 得到 `PONG 1278ms`，截图 `screenshots/D2-npm-proxy-fixed.png`；随后安装与构建成功。没有永久改系统代理，只影响当前终端。
2. **首次 build 的 TypeScript 类型错误。** 见上节与 `D3-build-type-error.png`。原因是实时模型目录新增了 opencode-go 的 Google api 模型，旧类型联合没有覆盖。按同仓库 `opencode.ts` 的四 api 写法补齐 `opencode-go.ts`，`D4-fix-diff.png` 记录改动，重新根构建后退出码 0。

## 简答

- 如何确保运行的是本地源码？用 `./pi-test.bat`，它调用 `tsx` 直接加载 `packages/coding-agent/src/cli.ts`；对照全局 `pi` 版本 1.5.0 和本地版本 0.86.1 也可以区分。
- 两个入口各适合什么场景？`src` 入口（`pi-test.bat`）适合边改源码边验证；`dist/bundle/cli.js` 是根 build 的产物，适合验证打包结果和脱离源码调试环境的运行。

## 截图索引

| 编号 | 文件 |
|---|---|
| S1 | `screenshots/S1-env-versions.png` |
| S2 | `screenshots/S2-git-info.png` |
| S3a/S3b | `screenshots/S3a-build-config.png`、`screenshots/S3b-engine-config.png` |
| S4a/S4b | `screenshots/S4a-install-finish.png`、`screenshots/S4b-install-exitcode.png` |
| S5a/b/c/d | `screenshots/S5a-build-progress.png`、`S5b-build-retry.png`、`S5c-build-finish.png`、`S5d-build-verify.png` |
| S6 | `screenshots/S6a-source-entry-version.png`、`S6d-entry-retry.png`、`S6e-source-chat.png` |
| 困难 D1–D4 | `screenshots/D1-npm-proxy-fail.png`、`D2-npm-proxy-fixed.png`、`D3-build-type-error.png`、`D4-fix-diff.png` |

Issue 标题：`实践课3：Pi Agent源码安装与编译 QuKaifeng`。Issue 需本人账号提交，当前未创建。
