/**
 * 选做验证：用 pptx Skill 推荐的 pptxgenjs 路线生成两页 PPT。
 *
 * 遵循 SKILL.md 的 footguns：
 *  - 先设 pres.layout 再加幻灯片
 *  - 颜色不带 #、不用 8 位 hex
 *  - 不复用 options 对象、不使用阴影
 *  - 列表用 bullet:true + breakLine（最后一项除外）
 *  - 每个输出文件只用一个 pptxgen 实例
 *
 * 运行：node make_two_slides.js
 */
const path = require("path");
const pptxgen = require("pptxgenjs");

const pres = new pptxgen();
pres.layout = "LAYOUT_WIDE"; // 13.3" x 7.5"
pres.author = "实践课一";
pres.subject = "Pi Agent 安装与基础使用";
pres.title = "第一次实践课：Pi Agent 安装与基础使用";

const NAVY = "1F3864";
const GRAY = "44546A";
const INK = "222222";

// ---------- 第 1 页：封面 ----------
const s1 = pres.addSlide();
s1.background = { color: "FFFFFF" };
s1.addText("Pi Agent 安装与基础使用", {
  x: 0.8, y: 1.0, w: 11.7, h: 1.0,
  fontFace: "Microsoft YaHei", fontSize: 40, bold: true, color: NAVY,
});
s1.addText("第一次实践课 · 六项任务实操记录", {
  x: 0.8, y: 2.05, w: 11.7, h: 0.5,
  fontFace: "Microsoft YaHei", fontSize: 20, color: GRAY,
});
s1.addText([
  { text: "环境：Windows 11 / Node.js 22 / Pi 1.5.0 / DeepSeek", options: { bullet: true, breakLine: true } },
  { text: "能力：模型切换、思考级别、文件引用、图片输入", options: { bullet: true, breakLine: true } },
  { text: "扩展：pi-web-access 插件与 pptx Skill", options: { bullet: true } },
], {
  x: 0.9, y: 3.1, w: 11.4, h: 2.2,
  fontFace: "Microsoft YaHei", fontSize: 18, color: INK,
  paraSpaceAfter: 12,
});
s1.addText("2026-11-14", {
  x: 0.8, y: 6.6, w: 11.7, h: 0.4,
  fontFace: "Arial", fontSize: 12, color: GRAY,
});

// ---------- 第 2 页：任务完成情况（表格 + 任务四的小图片） ----------
const s2 = pres.addSlide();
s2.background = { color: "FFFFFF" };
s2.addText("六项任务完成情况", {
  x: 0.8, y: 0.55, w: 11.7, h: 0.7,
  fontFace: "Microsoft YaHei", fontSize: 30, bold: true, color: NAVY,
});

const header = ["任务", "关键动作", "验证结果"].map((text) => ({
  text,
  options: { bold: true, color: "FFFFFF", fill: { color: NAVY } },
}));
const body = [
  ["一 安装启动", "官方安装器 / npm 全局安装", "Pi 1.5.0，可启动"],
  ["二 模型与会话", "API Key 登录 DeepSeek", "收到模型真实回复"],
  ["三 切换设置", "flash→v4-pro，low→high", "PI_MODEL 前后可核对"],
  ["四 文件与图片", "@hello.py、200×200 小图", "输出 5；识别蓝方块与 7"],
  ["五 插件", "pi install npm:pi-web-access", "工具加载 + 抓取标题"],
  ["六 Skill（选做）", "下载 56 文件到 .pi/skills/pptx", "启动发现 + /skill:pptx"],
].map((row) => row.map((text) => ({ text, options: { color: INK } })));

s2.addTable([header, ...body], {
  x: 0.8, y: 1.6, w: 10.2, h: 4.4,
  colW: [1.9, 4.6, 3.7],
  border: { pt: 0.5, color: "C9D2E3" },
  fontFace: "Microsoft YaHei", fontSize: 13,
  valign: "mid", margin: 0.08,
});

s2.addImage({
  path: path.join(__dirname, "..", "pi-test", "test-image.png"),
  x: 11.35, y: 4.5, w: 1.15, h: 1.15,
});
s2.addText("任务四素材", {
  x: 11.0, y: 5.75, w: 1.9, h: 0.35,
  fontFace: "Microsoft YaHei", fontSize: 11, color: GRAY, align: "center",
});

const out = path.join(__dirname, "两页演示.pptx");
pres.writeFile({ fileName: out }).then(() => {
  console.log(`已生成：${out}`);
});
