#!/usr/bin/env bash
# 实践课一「Pi Agent 安装与基础使用」证据采集脚本
# 所有 .txt 内容均为本机真实命令输出，重跑会覆盖。
# 用法：bash evidence/collect-evidence.sh
set -u

ROOT="D:/师大本科WORK/github/实践课1-Pi-Agent"
TEST="$ROOT/pi-test"
STUDY="$ROOT/study"
EV="$ROOT/evidence"
mkdir -p "$EV"

banner() { printf '\n===== %s =====\n' "$1"; }
stamp()  { echo "采集时间: $(date '+%Y-%m-%d %H:%M:%S %z')"; }
DETAILS="D:/师大本科WORK/github/pi-config/agent"

# ---------- 00 环境与安装 ----------
{
  stamp
  banner "运行环境（任务一）"
  echo '$ node -v';        node -v
  echo '$ npm -v';         npm -v
  echo '$ git --version';  git --version
  echo '$ pi --version';   pi --version
  echo '$ which pi';       which pi
  echo '$ pwd  (专用练习文件夹)'; (cd "$TEST" && pwd)
  banner "可用模型（pi --list-models）"
  pi --list-models
  banner "已安装包（pi list）"
  pi list
  banner "配置说明"
  echo "用户级配置目录 C:\\Users\\Lenovo\\.pi -> D:\\师大本科WORK\\github\\pi-config（符号链接）"
  echo "auth.json 已存在: $(test -f "$DETAILS/auth.json" && echo yes || echo no)  —— 内容含密钥，不展示、不提交"
  echo "models-store.json 已存在: $(test -f "$DETAILS/models-store.json" && echo yes || echo no)"
} > "$EV/00-环境与安装.txt" 2>&1

# ---------- S1 启动 ----------
{
  stamp
  banner "启动与版本（任务一 / 截图 S1 的文字等价证据）"
  echo '$ pi --version';   pi --version
  echo '$ pi --list-models'; pi --list-models
  banner "在专用练习文件夹中真实启动一次会话"
  echo "\$ cd $TEST && pi -p --model deepseek-flash \"请报告当前工作目录和当前模型，一句话即可。\""
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash \
    "请报告当前工作目录和当前模型，一句话即可。" < /dev/null)
  banner "说明"
  echo "Pi 已成功启动（非下载进度），版本 1.5.0；出现模型列表即表示客户端可用。"
  echo "TUI 截图 S1 需显示版本信息与当前工作目录，由本人在终端补拍。"
} > "$EV/S1-启动与版本.txt" 2>&1

# ---------- S2 首次会话 ----------
{
  stamp
  banner "配置模型后的一次最简单会话（任务二 / 截图 S2）"
  echo "配置方式：/login -> Sign in with an API key -> deepseek（密钥存于 ~/.pi/agent/auth.json，不展示）"
  echo "\$ cd $TEST && pi -p --model deepseek-flash \"你好\""
  banner "模型真实回复"
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash \
    "你好" < /dev/null)
  banner "说明"
  echo "验收重点：配置成功后能收到模型回复。未提交 auth.json、授权回调链接或完整密钥。"
} > "$EV/S2-首次会话.txt" 2>&1

# ---------- S3 模型与思考级别切换 ----------
{
  stamp
  banner "切换前：deepseek-flash / thinking low（任务三 / 截图 S3）"
  echo "TUI 等价命令：/model 或 Ctrl+L 选模型；/thinking 或 Shift+Tab 选思考级别"
  echo "\$ pi -p --model deepseek-flash --thinking low \"...\""
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash --thinking low \
    "请用 bash 工具列出所有 PI_ 开头的环境变量，据此说明当前模型 ID 与思考级别，再用一句话解释持续集成。" < /dev/null)
  banner "切换后：deepseek-v4-pro / thinking high"
  echo "\$ pi -p --model deepseek-v4-pro --thinking high \"...\""
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-v4-pro --thinking high \
    "请用 bash 工具列出所有 PI_ 开头的环境变量，据此说明当前模型 ID 与思考级别，再用一句话解释持续集成。" < /dev/null)
  banner "可用模型与其能力（pi --list-models）"
  pi --list-models
  banner "说明"
  echo "PI_MODEL / PI_REASONING_LEVEL 由 Pi 自身注入，是切换前后状态的客观证据。"
  echo "思考级别是推理设置，不是换模型，也不是显示/隐藏思考文本。"
  echo "简单事实问答用低级别即可；需要多步推理时再提高级别，代价是等待时间与用量增加。"
} > "$EV/S3-模型与思考级别切换.txt" 2>&1

# ---------- S4 @ 引用代码文件 ----------
{
  stamp
  banner "hello.py 内容与实际运行输出（任务四 A / 截图 S4）"
  echo '$ cat hello.py'; (cd "$TEST" && cat hello.py)
  echo '$ python3 hello.py'; (cd "$TEST" && python3 hello.py)
  banner "通过 @ 选中并引用文件后提问"
  echo "\$ cd $TEST && pi -p --model deepseek-flash -- @hello.py \"请解释 @hello.py 的功能，说明运行后输出什么。只解释，不修改文件。\""
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash -- @hello.py \
    "请解释 @hello.py 的功能，说明运行后输出什么。只解释，不修改文件。" < /dev/null)
  banner "说明"
  echo "@ 在 TUI 中用于从候选列表选中文件；CLI 用位置参数 @hello.py 完成同一引用。"
  echo "验收点：回复解释了 add 函数、给出输出 5，且文件未被修改。"
} > "$EV/S4-引用代码文件.txt" 2>&1

# ---------- S5 图片输入 ----------
{
  stamp
  banner "小图片素材（任务四 B / 截图 S5）"
  echo '$ python3 make_test_image.py'; (cd "$TEST" && python3 make_test_image.py)
  echo "图片：test-image.png，200x200，白色背景 + 蓝色实心方块 + 黑色数字 7"
  banner "把图片作为输入附加后提问"
  echo "TUI 操作：先把图像内容复制到剪贴板，按 Alt+V（或 Ctrl+V）粘贴，确认出现图片附件"
  echo "CLI 等价验证：用 @ 把图片文件作为附件送入模型"
  echo "\$ cd $TEST && pi -p --model deepseek-flash -- @test-image.png \"请描述图片中的颜色、形状和数字。\""
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash -- @test-image.png \
    "请描述图片中的颜色、形状和数字。" < /dev/null)
  banner "说明"
  echo "选用 deepseek-flash：pi --list-models 显示其 images=yes；deepseek-v4-pro 为 images=no。"
  echo "原始小图片见 pi-test/test-image.png，报告中同时插入以便核对识别结果。"
} > "$EV/S5-图片识别.txt" 2>&1

# ---------- S6 插件 ----------
{
  stamp
  banner "插件信息（任务五 / 截图 S6）"
  echo "名称：pi-web-access"
  echo "来源：Pi Packages https://pi.dev/packages （npm 包 pi-web-access@0.47.0）"
  echo "安装命令：pi install npm:pi-web-access   （用户级安装）"
  echo "作用：为 Pi 增加 web_search / source_check / fetch_content / get_search_content 等联网工具"
  echo "所需配置：零配置可用（Exa MCP），可选在 ~/.pi/agent/web-search.json 配置更多提供商"
  banner "pi list —— 已安装包与来源"
  pi list
  banner "加载证明：正常启动 vs --no-extensions 的可用工具对比"
  echo "\$ pi -p --model deepseek-flash \"请只列出你当前可用的工具名称...\""
  echo '[正常启动]'
  (cd "$TEST" && timeout 120 pi -p --no-session --model deepseek-flash \
    "请只列出你当前可用的工具名称，用英文逗号分隔，不要解释" < /dev/null)
  echo '[--no-extensions 启动]'
  (cd "$TEST" && timeout 120 pi -p --no-session --no-extensions --model deepseek-flash \
    "请只列出你当前可用的工具名称，用英文逗号分隔，不要解释" < /dev/null)
  echo "差值即为插件注册的工具，证明包不只是『已安装』而是『已加载』。"
  banner "最小功能调用：获取 https://example.com 的页面标题"
  echo "\$ pi -p --model deepseek-flash \"请使用网页抓取工具获取 https://example.com 的页面标题...\""
  (cd "$TEST" && timeout 150 pi -p --no-session --model deepseek-flash \
    "请使用网页抓取工具获取 https://example.com 的页面标题，并在回答中说明你实际调用了哪个工具（工具名）。" < /dev/null)
  banner "说明"
  echo "安装成功、加载成功、联网功能可用三者分别记录；TUI 重启后的 [Extensions] 区域截图由本人补拍。"
} > "$EV/S6-插件加载与调用.txt" 2>&1

# ---------- S7 Skill 目录与来源 ----------
{
  stamp
  banner "PPT Skill 安装来源（任务六 / 截图 S7）"
  echo '$ cat source-commit.txt'; (cd "$STUDY" && cat source-commit.txt)
  banner "文件总数"
  echo -n "文件数: "; (cd "$STUDY" && find .pi/skills/pptx -type f | wc -l)
  banner "目录结构（前三层）"
  (cd "$STUDY" && find .pi/skills/pptx -maxdepth 3 -printf '%y %p\n' | sort | head -70)
  banner "SKILL.md frontmatter"
  (cd "$STUDY" && head -12 .pi/skills/pptx/SKILL.md)
  banner "说明"
  echo "安装位置为项目级 .pi/skills/pptx（不是随便放在 study/pptx），Pi 才会自动发现。"
  echo "保留 SKILL.md、LICENSE.txt 与 scripts 全部支持文件，共 56 个，源 commit 已记录。"
} > "$EV/S7-Skill目录与来源.txt" 2>&1

# ---------- S8 Skill 发现与调用 ----------
{
  stamp
  banner "重新启动后的自动发现（任务六 / 截图 S8）"
  echo "\$ cd $STUDY && pi -p --mode json ...   （从启动系统提示中提取 <available_skills>）"
  (cd "$STUDY" && timeout 120 pi -p --no-session --approve --mode json --model deepseek-flash \
    "请只回答：OK" < /dev/null > "$EV/.startup-raw.json" 2>&1)
  python3 "$EV/extract_startup_info.py" "$EV/.startup-raw.json"
  rm -f "$EV/.startup-raw.json"
  banner "显式调用 /skill:pptx"
  echo "\$ cd $STUDY && pi -p \"/skill:pptx 请说明这个 Skill 的名称、用途和所在目录\""
  (cd "$STUDY" && timeout 150 pi -p --no-session --approve --model deepseek-flash \
    "/skill:pptx 请说明这个 Skill 的名称、用途和所在目录" < /dev/null)
  banner "说明"
  echo "发现位置必须指向本次安装路径；安装成功、发现成功、调用成功分三层记录。"
} > "$EV/S8-Skill发现与调用.txt" 2>&1

echo "证据采集完成，输出目录：$EV"
ls -1 "$EV"
