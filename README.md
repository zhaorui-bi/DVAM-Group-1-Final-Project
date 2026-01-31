# DVAM Group 1 Final Project | Sweden Biodiversity and Climate Information Facility Interactive Visualization Platform📊

[![License](https://img.shields.io/badge/License-APSL%202.0-blue.svg)](https://opensource.org/licenses/APSL-2.0)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://www.python.org/)
[![Course](https://img.shields.io/badge/Course-DVAM-green)]()
[![Status](https://img.shields.io/badge/Status-Completed-success)]()

## 📖 项目背景 (Abstract)

DVAM Group 1 Final Project | Sweden Biodiversity and Climate Information Facility Interactive Visualization Platform 项目立足于宏观生态学、数据科学与气候信息学的交叉领域，核心任务是构建一个鲁棒的计算管道，用于实现全球生物多样性信息网络（GBIF）的物种分布数据与 CHELSA（高分辨率地表气候及其相关数据）气候栅格数据的自动化集成。   

在当前“人类世”的地质时代背景下，生物多样性的丧失速度达到了前所未有的水平。为了制定有效的保护策略，研究人员必须理解物种与其环境之间的复杂关系。这种关系通常被称为“生态位”（Ecological Niche）。然而，量化生态位面临着巨大的技术瓶颈：生物数据通常是以离散的、基于矢量的“点”数据形式存在（例如，博物馆标本的经纬度记录），而环境数据（如温度、降水）则通常存储为连续的、基于栅格的“面”数据（如 GeoTIFF 格式的卫星遥感影像）。DVAM Group 1 项目正是为了解决这一异构数据融合问题而设计，通过 Python和R 编程环境，利用 pygbif 和 rasterio 等工具库，实现了从数据获取、清洗、空间提取到高维可视化的全流程自动化。

## ✨ 核心亮点与可视化 (Key Features & Visualizations)

Sweden Biodiversity and Climate Information Facility Interactive Visualization Platform 将抽象数据转化为直观的科学图表：

**地理空间 (G-Space)**：

- 使用 Folium 生成交互式地图，支持在大尺度上查看物种分布与气候图层的叠加效果。   

**环境空间 (E-Space)**：

- 生态位可视化：利用 Seaborn 绘制小提琴图，展示物种对温度/降水的耐受范围。   

- 降维分析：通过主成分分析（PCA）处理高维气候变量，量化不同物种在环境空间中的生态位重叠度。

**交互式网站平台(Interactive Visualization Platform)**


## 📂 目录结构 (Directory Structure)

本仓库的文件组织结构如下：

```text
DVAM-Group-1-Final-Project/
├── video/                  # 交互式可视化视频
│   ├── Asterales_heatmap.mp4     
│   └── Passeriformes_heatmap.mp4
├── data/                   # 数据源文件和数据预处理脚本.R
│   ├── preprocess.R        
├── visualization/          # 可视化Jupter Notebook(核心图)
│   ├── occurrence_visualization.ipynb
├── requirements.txt        # 项目依赖库列表
├── LICENSE                 # 许可证文件
└── README.md               # 项目说明文档
```

## 🚀 快速开始 (Quick Start)

### 1. 克隆仓库

```bash
git clone https://github.com/zhaorui-bi/DVAM-Group-1-Final-Project.git
```

### 2. 安装依赖

```bash
pip install uv
uv pip install -r requirements.txt
```

### 3. 数据预处理与分析

数据原文件大于100MB无法直接上传在GitHub当中, 我们提供了一个Google Drive Link下载数据: 

https://drive.google.com/file/d/1DxBIXcHfnpuYyYtIi6pVG3LIbPpVbLjc/view?usp=drive_link

具体预处理结果和可视化结果在Jupyter Notebook当中

```bash
src/occurrence_visualization.ipynb
```

### 4. 可视化交互

https://github.com/user-attachments/assets/c441041d-fdf7-4364-8286-92fa1089198d

https://github.com/user-attachments/assets/ff6436c1-9556-4cfd-8433-1a60afc66ec6

### 5. 网站可视化



https://github.com/user-attachments/assets/7e510669-51b3-44b0-8932-767ea249c9ea



## 👥 小组成员 (Contributors)

感谢以下团队成员对本项目做出的贡献：

| 姓名 | 主要职责 (Role) | GitHub |
| --- | --- | --- |
| **姜肇瑞** | 项目统筹, 数据搜集预处理, 文档撰写 | [@zhaorui-bi](https://github.com/zhaorui-bi) |
| **徐子洋** | 可视化分析代码编写 | [@xzy-Zayn](https://github.com/xzy-Zayn) |
| **程梓雄** | 数据预处理, 文档撰写 | [@orangebear-star](https://github.com/orangebear-star) |
| **范竞元** | 网站可视化 | [@t13yu](https://github.com/t13yu) |

## 📄 许可证 (License)

本项目采用 **Apple Public Source License 2.0 (APSL-2.0)** 开源许可证。
详情请参阅 [LICENSE](LICENSE) 文件或访问 [Open Source Initiative](https://opensource.org/licenses/APSL-2.0) 查看完整条款。

## 🖊️ 引用 (Citation)

如果您在学术研究或项目中参考了本仓库的内容，请使用以下 BibTeX 格式进行引用：

```bibtex
@misc{DVAMGroup12026,
  author       = {Jiang, Zhaorui and
                  Xu, Ziyang and
                  Cheng, Zixiong and
                  Fan, Jingyuan},
  title        = {DVAM Group 1 Final Project: Sweden Biodiversity and Climate Information Facility Interactive Visualization Platform},
  howpublished = {\url{https://github.com/zhaorui-bi/DVAM-Group-1-Final-Project}},
  year         = {2026},
  note         = {GitHub repository}
}
```

## 🙏 致谢 (Acknowledgments)

* 感谢 **余珂** 教授在 DVAM 课程中的悉心指导。
* 数据集来源：[GBIF](https://www.gbif.org/) and [CHELSA](https://www.chelsa-climate.org/)

---

*Last updated: Jan 30 2026*
