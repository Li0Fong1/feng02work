# 实践课一：Pi Agent 安装与基础使用

- 姓名：瞿凯峰　学号：202430194023　姓名拼音：QuKaifeng
- 环境：Windows 11 / PowerShell 5.1 / Node.js v22.22.2 / npm 10.9.7 / Git 2.55.0
- Pi 版本：1.5.0（已通过官方安装器 / npm 全局安装）
- 模型提供方：DeepSeek（API Key 方式，密钥存于 `~/.pi/agent/auth.json`，**不纳入本仓库**）
- 练习目录：`pi-test/`；选做任务六目录：`study/`
- 采集日期：2026-11-14

> **提交状态：按本人要求，作业已写好但「先别交上去」** —— 未 push 到任何远程仓库、未创建 Issue。
> 本轮新增的 16 张真实界面截图、报告与说明文件仅保存在本地工作区。

## 一句话结论

六项任务 + 选做全部在本机**真实执行**：安装与启动、模型配置与会话、模型/思考级别切换、`@` 引用代码、图片输入、插件加载与调用，以及 PPT Skill 安装—发现—调用—生成全链路。S1–S8 共 **16 张交互式界面截图**已在真实 Windows 终端窗口中逐项操作并对屏幕实拍，全部插入 `实践报告.docx`。

## 目录结构

```text
实践课1-Pi-Agent/
├── README.md                      本说明
├── 实践报告.docx                   提交用实验报告（含 16 张真实界面截图 + 原始小图）
├── 截图清单.md                     16 张真实截图的清单、画面内容与自检结果
├── issue模板.md                    任务七：已填好个人信息的 Issue 模板（暂未提交）
├── .gitignore                     排除密钥、node_modules、生成流水线中间产物
├── pi-test/                       专用练习文件夹
│   ├── hello.py                   任务四 A 的被引用代码
│   ├── make_test_image.py         任务四 B 小图片生成脚本（纯标准库）
│   └── test-image.png             200×200 蓝方块 + 数字 7
├── study/                         任务六项目目录
│   ├── download_pptx_skill.py     Skill 下载安装脚本（记录源 commit）
│   ├── source-commit.txt          源仓库 / commit / 文件数
│   ├── make_two_slides.js         选做：用 pptxgenjs 生成两页 PPT
│   ├── 两页演示.pptx              选做产物（通过 Skill 的 OOXML 校验）
│   └── .pi/skills/pptx/           完整 Skill 目录（56 个文件）
├── evidence/                      真实命令输出证据
│   ├── collect-evidence.sh        一键重跑全部验证
│   ├── extract_startup_info.py    从启动输出提取 <available_skills>
│   ├── 报告素材.md                报告正文底稿（含截图引用）
│   ├── 00-环境与安装.txt
│   ├── S1-启动与版本.txt … S8-Skill发现与调用.txt
│   └── 选做-两页PPT生成与校验.txt
└── screenshots/                   16 张真实屏幕捕获的 S1–S8 界面截图
```

## 任务完成情况

| 任务 | 内容 | 状态 | 关键证据 |
|---|---|---|---|
| 一 | 本地安装并启动 Pi | 已完成 | `S1-安装启动.png` + `00-环境与安装.txt` |
| 二 | 配置模型并完成一次会话 | 已完成 | `S2-配置与会话.png`（真实提示词与回复） |
| 三 | 切换模型与思考级别 | 已完成 | `S3a`–`S3d` 四张界面图 + `PI_MODEL` / `PI_REASONING_LEVEL` 文本证据 |
| 四 A | `@` 引用 hello.py | 已完成 | `S4a`（候选列表选中）、`S4c`（引用+问题+回复同屏） |
| 四 B | 粘贴小图片测试 | 已完成（真实 Alt+V） | `S5a`（图片附件）、`S5b`（识别蓝色方块与 7） |
| 五 | 安装并使用插件 | 已完成 | `S6a`（`[Extensions] pi-web-access:dist`）、`S6b`（功能调用） |
| 六 | AI 安装 PPT Skill（选做） | 已完成（四层全通） | `S7`、`S8a`（`[Skills] pptx`）、`S8b`（`/skill:pptx` 与安装路径）；两页 PPT 通过校验 |
| 七 | 上传到个人仓库并发 Issue | **按要求暂缓** | `issue模板.md` 已填好，未 push、未发 Issue |

## 关于截图（重要）

这 16 张不是示意图、不是把命令行输出渲染成图片，也不含任何生成图：

1. 用 `wt.exe` 打开真实 Windows Terminal 窗口，在 `pi-test` / `study` 目录中启动真实 `pi` 会话；
2. 用 SendInput 向该窗口键入真实按键与文本（`/model`、`/thinking`、`@`、`Alt+V`、`/skill:pptx` 等）；
3. 用 Pillow `ImageGrab.grab()` 抓取**物理屏幕像素**保存为 PNG；
4. 逐张人工核对画面内容后，按 S1–S8 插入 `实践报告.docx`（Word 内共 16 张 `word/media/*.png`）。

真实操作中还遇到并记录了：`Trust project folder?` 项目信任确认、`Alt+V` 需要剪贴板里是 CF_DIB 图像像素、
`Ctrl+D` 在该终端无法退出因而另开全新会话、长回复需补拍同屏图。细节见 `截图清单.md` 与报告第八章。

## 一键复现

```bash
bash evidence/collect-evidence.sh
```

脚本会重新执行全部命令行验证并覆盖 `evidence/*.txt`，需要本机已登录 DeepSeek 且网络可用。
界面截图为人工/脚本驱动的真实屏幕捕获，不由此脚本重生成。

## 安全与合规

- `auth.json`、API Key、授权回调链接、完整密钥一律**不展示、不提交**；`.gitignore` 已排除。
- 报告与证据中只出现模型名称、命令、公开输出与插件的公开信息。
- 任务六下载的 Skill 保留原仓库 `LICENSE.txt`，仅用于课程练习。

## 任务七：提交方式（**现在不要执行**）

1. 把本目录作为个人 Git 仓库推送到自己的 GitHub / Gitee / GitCode 账号；
2. 打开教师统一入口的 Issue 页面，按 `issue模板.md` 发起作业地址；
3. Issue 名称：`实践课1： Pi Agent安装与使用 QuKaifeng`；
4. 正文附上个人仓库 URL，并按课程要求补充 label。

当前只有一次本地提交（`277fa3c`），本轮补充内容未提交、未推送。
