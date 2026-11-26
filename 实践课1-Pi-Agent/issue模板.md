# 任务七：Issue 提交模板（**按要求暂未提交**）

> ⚠️ 本文件只是**填好的模板**。用户明确要求「先别帮我交上去」，因此：
> **未 push 到任何远程仓库、未创建任何 Issue**。个人仓库 URL 仍需本人填写。

姓名：瞿凯峰　学号：202430194023　姓名拼音：QuKaifeng

## Issue 名称（固定格式，已填好）

```text
实践课1： Pi Agent安装与使用 QuKaifeng
```

## Issue 正文模板（待仓库地址补齐后使用）

```text
姓名：瞿凯峰
学号：202430194023
姓名拼音：QuKaifeng（与 Issue 标题一致）
个人仓库地址：[待填写：https://github.com/<你的账号>/<仓库名>]
作业目录：仓库根目录下的「实践课1-Pi-Agent/」

一、完成情况
1. 本地安装并启动 Pi：Pi 1.5.0，Node.js v22.22.2，npm 10.9.7，Windows 11
2. 配置模型并完成一次会话：DeepSeek API Key 方式，deepseek-flash 已返回回复
3. 切换模型与思考级别：deepseek-flash / high → deepseek-v4-pro / off
   （真实界面中 /model 与 /thinking 选择器、切换前后状态见 S3a–S3d）
4. @ 引用代码文件：从候选列表选中 hello.py，模型正确说明 add 函数与输出 5
5. 粘贴小图片测试：Alt+V 粘贴 200×200 蓝方块 + 数字 7，模型正确识别
6. 安装并使用插件：pi-web-access（npm:pi-web-access），[Extensions] 已加载并抓取 example.com 标题
7. PPT Skill（选做）：anthropics/skills 的 skills/pptx，56 个文件，
   源 commit 2c5958ecac7cee2b583967a2c4981d0f4a75c579，
   已通过 [Skills] 启动发现、/skill:pptx 调用与两页 PPT 生成（All validations PASSED!）验证

二、材料位置
- 实验报告：实践报告.docx（含 16 张真实界面截图）
- 截图：screenshots/S1…S8 共 16 张，全部为真实屏幕捕获
- 真实命令输出：evidence/00…S8 共 10 个 .txt
- 一键复现：bash evidence/collect-evidence.sh

三、说明
- 未提交 auth.json、API Key、授权回调链接或任何密钥。
- 交互界面截图来自真实 Windows 终端窗口的屏幕捕获，未做渲染或合成。
```

## 提交前检查

- [ ] 个人仓库已设为公开并可访问（**当前未创建/未推送**）
- [x] 仓库中不含 `auth.json`、`.env`、任何密钥文件（见 `.gitignore`）
- [x] `实践报告.docx` 中 S1–S8 截图已全部插入（16 张，含真实界面）
- [x] Issue 标题中的姓名拼音与正文一致（QuKaifeng）
- [ ] 按课程要求选择/补充对应 label
- [ ] 由本人账号发起，不代交、不在公开 Issue 写敏感信息

## 待本人执行的推送命令（**现在不要执行**）

```bash
cd "D:/师大本科WORK/github/实践课1-Pi-Agent"
git remote add origin <你的个人仓库URL>
git push -u origin main
```

本目录已 `git init -b main` 并有一次本地提交（commit `277fa3c`）；本轮补充的截图、报告与说明文件
**只保存在本地工作区，未再做提交、未推送**。若要一并提交，先 `git add -A && git commit`，再 push。
