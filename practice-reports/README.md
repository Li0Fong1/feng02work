# 实践课 1–5 交付汇总与自检

姓名：瞿凯峰　学号：202430194023　姓名拼音：QuKaifeng
整理日期：2026-11-26

## 一、开始前的状态与本次补做内容

| 实践 | 开始前状态 | 本次完成 |
|---|---|---|
| 01 Pi Agent 安装与基础使用 | 报告、16 张真实截图、Issue 模板均已写好；**未 push、未发 Issue**（本人此前要求暂缓） | 未改动，保留原样 |
| 02 组织建仓与源码分析 | 小组仓库已 clone，但**没有报告、没有组织仓库/目录截图、没有依赖图** | 补齐报告、模块分析依据、组织仓库网页截图、本地 clone 信息截图、源码目录截图、Mermaid 图源 |
| 03 源码安装与编译 | 源码已下载但**没有 node_modules/dist、没有环境/安装/构建/运行截图与报告** | 真实安装、编译、验证、本地源码会话；记录两类困难；补齐报告与 20 张截图 |
| 04 模型调用与运行流程 | **完全未做** | 加两处 [P4] 日志、重新编译、A/B 两次会话、真实日志、报告与运行简图 |
| 05 源码泛读与功能定位 | **完全未做** | handoff.txt 实验、-c 恢复与 /new 对照、两张 Mermaid 图与报告 |

## 二、本次交付目录

```text
practice-reports/
├── README.md                          本文件
├── practice-02/
│   ├── practice-02.md                 组织建仓与源码分析报告
│   ├── 模块分析-源码依据.md            逐包逐文件依据（含完整表格与图源说明）
│   ├── dependencies.mmd               依赖关系图（可编辑）
│   └── screenshots/                   3 张真实截图
├── practice-03/
│   ├── practice-03.md                 安装编译与困难记录报告
│   ├── install-log.txt                真实安装日志
│   ├── build-log-first-fail.txt       首次构建失败日志
│   ├── build-log-success.txt          重新构建成功日志
│   └── screenshots/                   20 张真实截图
├── practice-04/
│   ├── practice-04.md                 运行流程报告
│   ├── p4-code-diff.txt               agent-loop.ts 两处日志的文本差异
│   ├── runtime-flow.mmd               运行简图（可编辑）
│   ├── A2-stderr.txt / B-stderr.txt   两次会话真实 stderr 日志
│   ├── build-log.txt                  重新构建日志
│   └── screenshots/                   12 张真实截图
└── practice-05/
    ├── practive-05.md                 源码泛读报告（文件名按作业原文）
    ├── figure1-sequence.mmd            单轮工具调用时序图（可编辑）
    ├── figure2-session-branches.mmd    会话恢复/新建对照图（可编辑）
    ├── A-stderr.txt / B-stderr.txt     真实 stderr 日志
    └── screenshots/                   5 张真实截图
```

## 三、真实性自检

- 所有截图均为真实 Windows 桌面像素捕获：Windows Terminal/PowerShell、Microsoft Edge、文件资源管理器、终端内 GNU nano。没有生成、拼贴或伪造界面。
- 所有版本号、提交号、包数量、漏洞数量、模型回复、`[P4]` 日志均来自真实命令输出或真实界面，并保存了原始日志文本。
- 报告中 55 处 `screenshots/*.png` 引用全部存在，无缺失。
- 报告中没有完整 API Key、`auth.json` 内容或授权回调链接；模型回复截图不含密钥。
- 实践 01 的 `实践报告.docx` 与 16 张截图沿用此前已核对版本，未重新生成。

## 四、源码仓库的本地改动

`D:\师大本科WORK\github\pi-hunnu-2026` 当前有四处未提交改动/新增，都是本次实战产生的真实证据：

| 路径 | 改动 | 用途 |
|---|---|---|
| `packages/ai/src/providers/opencode-go.ts` | 补 `google-generative-ai` 适配器，修正实时模型目录导致的 TS2322 | 实践 3 构建成功的必要修复 |
| `packages/agent/src/agent-loop.ts` | 两处 `[P4] console.error` | 实践 4 的观察日志 |
| `practice4.txt` | 实验代号 `P4-QKF-20261126` | 实践 4 会话 B |
| `handoff.txt` | 交接单两行，标识 `river-35089c` | 实践 5 会话 A |
| `p5-B1-stderr.txt` | 实践 5 会话日志副本 | 已归档到 `practice-05/B-stderr.txt`；本机安全删除策略拦截了删除，可忽略 |

这些改动未 commit、未 push。是否提交到小组仓库由本人决定；报告与截图已经能独立证明过程。

## 五、仍需本人完成的操作

1. 把本报告目录（及实践 01 的 `实践课1-Pi-Agent/`）复制到个人作业仓库并 push。此前使用的个人仓库是 https://github.com/Li0Fong1/feng02work ，也可以用其他个人仓库。
2. 在课程作业仓库 https://github.com/hunnuOpenSourceSoftware2026/assignments/issues 分别发起 5 条 Issue，正文附个人报告链接（实践 2 另附小组仓库链接）：
   - `实践课1： Pi Agent安装与使用 QuKaifeng`
   - `实践课2：组织建仓与源码分析 QuKaifeng`
   - `实践课3：Pi Agent源码安装与编译 QuKaifeng`
   - `实践课4：Pi Agent模型调用与运行流程 QuKaifeng`
   - `实践课5：Pi Agent工具调用与会话恢复 QuKaifeng`
3. 上传后检查图片与 Mermaid 图能否正常显示；若个人仓库对中文路径敏感，可改成英文文件名后同步更新报告引用。
4. 是否把小组源码仓库的本地改动 commit/push，由本人和组长确认后再做。
