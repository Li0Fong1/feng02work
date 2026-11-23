# 关于本项目

## 项目目标

把本地 Markdown 笔记变成一个公开网页，并且做到改完文档推上去，网站自己更新，不用手工传文件。

## 技术组成

| 工具 | 作用 |
| --- | --- |
| Markdown | 写四页内容 |
| MkDocs Material | 把 `docs/` 编译成 `site/` 静态网页 |
| GitHub Actions | 推送后自动装依赖、构建、上传产物 |
| GitHub Pages | 托管 `site/`，给出公开访问地址 |

## 几个目录分别放什么

`docs/` 是我手写的源文件，改内容都在这里改。`site/` 是 `mkdocs build` 跑出来的结果，每次构建都会重新生成，所以不提交到 main，`.gitignore` 里也排除了它。`.github/workflows/deploy.yml` 写自动化的步骤，`report/` 放这次实验的过程记录和截图。

导航写在 `mkdocs.yml` 的 `nav` 里，路径是相对 `docs/` 的。写成 `docs/index.md` 反而找不到文件，这个我一开始差点写错。

## 一点体会

以前觉得「部署」是个挺重的动作，这次做完发现主要就是三件事：把文件放到约定的目录、把构建命令写进工作流、把 Pages 的来源设成 GitHub Actions。真正花时间的是排查本机网络和 git 的 TLS 后端，页面本身反而没花多久。

四页之间可以互相跳：[首页](index.md)、[使用指南](guide.md)、[API 参考](api.md)。
