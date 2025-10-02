---
title: "AI for Paleography: A Toy Survey"
date: 2025-10-02
categories: [Technical, Paleography]
---

> 出于研究群体实际，1）本文将使用中文写作；2）本文将“古文字”“古文字学”局限在“古汉字”当中。若读者对于全人类范围、最广泛意义的古文字处理感兴趣，不妨参考：[Ancient Script Image Recognition and Processing: A Review](http://arxiv.org/abs/2506.19208)

<img width="777" height="311" alt="B6931" src="https://github.com/user-attachments/assets/43b47f42-a017-4b12-b517-d1f395e9a32c" />

## 预备知识

古文字学是集合历史学、考古学、语言学、古文献学等多学科知识与方法的一门新兴交叉学科。从传统来看，呈现出**知识密集、经验密集、重实证**的特点。

<img width="419" height="387" alt="Figure 1 Examples of an oracle bone (a) and its corresponding" src="https://github.com/user-attachments/assets/a83fd76a-423f-4c3d-9929-c70ea1535ab5" />


根据《出土文献与古文字教程》，经典意义上，古文字研究大致的范围是：从商代甲骨文到汉代带有篆书结构或意味的隶书的各类文字。出土文献是用古文字来记录的，古文字记录的是出土文献，在比较泛的语境中说的是一回事。

按照时间顺序和时代分类，出土文献与古文字大体可以分为：**商代文字、西周文字、春秋战国文字、秦汉文字**四大时段。还可以按照出土文献与古文字所依附的物品来分类（**甲骨、金文、简牍、帛书**……）；把出土文献中带有较长篇幅的篇章视为文学作品的角度分类（诗歌、散文、骈文、赋……）；把出土文献中带有思想性、艺术性、学派观点且又较长篇幅的篇章视为书籍，按照《汉书·艺文志》的分类（六艺、诸子、诗赋、兵书、术数、方略）。

- 甲骨文：多占卜（卜辞），少量记事（记事刻辞）
- 西周金文：记功赏赐、买卖记录、重大事件或法律案件的记载
- 春秋以下： 
    - 祭祷、诅祝、物勒工名 
    - 个人和学派思想的著作，现在真正意义上的"书"大量出现（秦汉简牍帛书）
- 战国竹简：官的系统有大量的法律文书和行政文书；私的系统是大量民间的日书
- 内含：大传统（儒道思想、精英思想文化）、小传统（阴阳五行）

秦始皇焚书坑儒，秦代出土文献只有法律文书和行政文书、告示、诏令、官箴、日书等，说明秦代的禁书政策很有实效。汉惠帝时废除挟书律，民间才可以阅读各种有思想性的著作，因此汉代的出土文献中就开始出现儒道等不同思想家的著作了。

古文字研究中的一些基本任务：
- 文字层面：释读、上古音、词汇、古籍……
- 文献层面：缀合、校重、辨伪、断代……

当前古文字学面临的主要问题在于：

- 古文字资料整理任务艰巨，缺乏统一标准规范，重复性工作多
- 高水平的古文字考释、疑难字词考释亟待突破
- 理论方面，系统性揭示古文字形体构造和发展规律的成果较少
- 对研究者的文史知识、古文字基础、信息技术素养要求极高

古文字研究与智能技术结合，有望为古文字与出土文献研究带来新机遇。

> 复旦大学出土文献与古文字研究中心：《出土文献与古文字教程》，上海：中西书局，2024年1月。
> 
> 黄德宽：《新时代古文字学学科建构》，《历史研究》2024年第12期。
> 
> 莫伯峰：《"计算古文字学"正在路上》，《光明日报》2022 年 10 月 30 日，第5版。


## 信息化资源建设

### 甲骨文手写字符数据集

- Oracle-20K：20,039张手写图像，261类，类别分布不均衡（25-291张/类）
- SOC5519：44,868张样本，5,491类，几乎涵盖所有已知类别，专家手工描摹制作
- Oracle-AYNU：39,062张实例，2,583类，其中662类仅有2个实例
- Oracle-50K/Oracle-FS：59,081张图像，2,668类；Oracle-FS支持少样本学习（200类）
- HWOBC：83,245张历史文本样本，3,881类，分布相对均衡
- Oracle-250/Radical-148：Oracle-250包含250个最频繁类别，92,160个平衡样本；Radical-148包含148个常见部首
- Ancient-3/Ancient-5：各含1,186类，39,009张样本，Ancient-3包含金文和楚文字，Ancient-5增加秦文字和小篆
- ORCD/OCCD：ORCD为部首数据集（6,700样本，64个部首类）；OCCD包含54,876个合成字符和7,310个手写字符
- **HUST-OBC**：华中科技大学Wang等人(2024)在Scientific Data发表；140,053张图像，包含77,064张已释读字符（1,588类）和62,989张未释读字符（9,411类）；来源：新甲骨文编、甲骨文六位数字码检索字库、国学大师、殷契文渊、安阳师范公开数据集
- Oracle-P15K: 上海交大、华东师大Li等人(2025)结合专家知识，构建了一个大规模（14,542个实例）、结构层面对齐（structure-aligned）的甲骨文图像成对数据

<img width="982" height="361" alt="Pasted Graphic 8" src="https://github.com/user-attachments/assets/94b08d63-2d50-48e1-ae88-6bd28fb642bb" />
<img width="962" height="382" alt="B3734" src="https://github.com/user-attachments/assets/e4b17d14-098f-4b12-9c77-2475fa092528" />


### 甲骨文扫描字符数据集

- OBC306：309,551个实例，306类，主要为扫描图像，存在严重噪声和类别不平衡
- OBI125：从1,056张拓片中手工分割得到4,257个字符，125类
- Oracle-MNIST：30,222张扫描图像，10个常用类别，存在严重噪声
- Oracle-241：78,565个实例，241类，包含手写和扫描数据

### 金文数据集

针对金文识别问题，Wu等人(2022)提出了基于反向传播神经网络的识别方法，专门用于青铜图像分类。他们的研究构建了一个包含100个不同青铜图像的训练数据集，每个图像关联10个样本，以及一个包含256个样本的独立测试集。该模型依赖于融合像素级信息和局部特征的特征提取策略，最终实现了93.3%的识别准确率。

### 简帛文字数据集

清华大学团队构建了首个大规模楚系简帛文字数据集（超过100K标注字符图像扫描），支持多粒度分析。秦简文字方面，陈明等人(2025)构建了国内首个秦简文字单字样本库（66,973张）。

### 小篆数据集

Xu等人(2025)构建了第一个大规模中文印章数据集，包括各种颜色和难度级别的印章。他们开发了检测、分割和识别的完整流水线，并使用YOLOv3和相关架构建立了基线模型。

### 多模态数据集

**OBIMD (oracle bone inscriptions multi-modal dataset)**：10,077片甲骨的完整标注信息，包含检测框、字符类别、转录、铭文组和阅读序列，用于全任务（检测、分类、去噪、生成、序列预测、缺字补全等）

<img width="1026" height="476" alt="Pasted Graphic 34" src="https://github.com/user-attachments/assets/aa32238a-83fc-4dda-a215-5f6793360b76" />


### 复杂场景数据集

Qi等人(2024)提出AncientGlyphNet，使用精心设计的特征转换工程训练模型，解决复杂场景（如：照片、书法作品等）中的古文字检测。构建了HUSAM-SinoCDCS数据集，涵盖石刻、书法、对联等。

<img width="757" height="573" alt="Pasted Graphic 12" src="https://github.com/user-attachments/assets/91a0c87d-da52-42af-b7dc-c2f8c3e1cc47" />


### 专用数据集

- **EVOBC**：收集六个历史阶段古文字演化（甲骨、金文、篆书、春秋、战国、隶书），其中甲骨文75,681张图像，3,077类
<img width="882" height="622" alt="st" src="https://github.com/user-attachments/assets/c78be273-0e93-482e-9abb-5febc808e750" />

- RCRN：专门用于字符图像降噪，包含1,467对训练样本和139对测试样本
- ACCID：提供字符级和部首级标注，2,892个字符类（15,085张图像），595个部首类（28,143个样本）
- OracleRC：2,005个字符类，可分解为202个部首和14种结构关系
- Radical-Pictographic Decipherment OBS Dataset: Peng等人(2025)提出一种基于大视觉语言模型（LVLM）的部首分析破译方法，构建了包含47,157类甲骨文字形与对应象形分析文本的数据集。
<img width="484" height="592" alt="toT" src="https://github.com/user-attachments/assets/adfadfd4-57d3-43fa-ab75-c0a6bbf439c4" />


- OracleSem: Jiang等人(2024)的OracleSage框架中附带提出一个包含甲骨文字形、字形描述和分析的数据集，包含1,762个字形，每个字形10到20张图片。

<img width="440" height="306" alt="OBS Imoges" src="https://github.com/user-attachments/assets/f184bf20-a9bf-4237-87b7-b58708ac7bf5" />


- PicOBI-20k：Chen等人(2025)将20k个甲骨文字形与现实世界物体配对，人工标注物体上的参照点，构建超过15k个多选题评估多模态大模型的视觉推理（根据甲骨文选择图片）能力
<img width="972" height="560" alt="Pasted Graphic 40" src="https://github.com/user-attachments/assets/e62ef2f3-8400-49c0-beab-16fa70f5c785" />
<img width="474" height="215" alt="Real Object" src="https://github.com/user-attachments/assets/fceb8cd3-e751-4999-8fd5-91f8231917ae" />



## 图像处理与降噪

古文字图像普遍存在噪声、破损、模糊等问题，图像预处理成为关键环节：

### 降噪算法

- Wang等人(2022)引入了结构-纹理分离网络（STSN），将文字结构从背景噪声中分离出来。
<img width="667" height="426" alt="boundary" src="https://github.com/user-attachments/assets/1cf78d8e-9aff-4aee-a7f4-57df5ea64295" />

- Li等人(2025)提出的OBIFormer采用快速注意力降噪框架，利用通道级自注意力、字形提取和选择性核特征融合来精确重建降噪图像。
- Miao等人(2022)基于中文字符书写标准模型（田字格）提出一种结合全局分支（global branch）和局部分支（local branch）的生成对抗网络古文字图像降噪方法，在PSNR和SSIM指标上分别提升23.8%和11.4%。

<img width="460" height="299" alt="Vertical center line" src="https://github.com/user-attachments/assets/6e52ba48-aef8-4ab6-9866-ceae4e9271e4" />
<img width="764" height="414" alt="Figure 4  The overall structure of the Chinese character writing standard model" src="https://github.com/user-attachments/assets/fb5c3d3f-5fe8-45d6-8fc5-cd4d9bae2507" />


### 数据增强

- 针对古文字数据稀缺问题，除了传统方法（随机擦除、剪切、反转、旋转、亮度变化等），Li等(2024)基于扩散模型，分别对内容和风格编码和学习，生成可控甲骨文字形；
- Li等人(2025)提出OBIDiff扩散模型，能够实现可控的甲骨文生成;
- Huang等人(2023)的AGTGAN通过无监督生成对抗网络实现古文字图像生成，分类准确率提升达16.34%。针对变体多样问题，提取固定拓扑表征、拆解为偏旁部首（radicals）等。

<img width="470" height="258" alt="Style Images" src="https://github.com/user-attachments/assets/f2804625-6a7b-4261-a962-1ce4e732ab26" />
<img width="440" height="239" alt="Oracle bone" src="https://github.com/user-attachments/assets/8810e8be-7784-4c20-85d0-05bbbde6b081" />
<img width="428" height="389" alt="CycleGAN" src="https://github.com/user-attachments/assets/0177f24f-d3cb-4b38-b9e9-206dc1ed60c8" />


### 图像修复

Duan等人(2024)提出多模态多任务修复模型(MMRM)，结合上下文理解和残留视觉信息，同时预测损坏字符和生成修复图像。

<img width="443" height="488" alt="Damaged Image" src="https://github.com/user-attachments/assets/590772c6-f277-428f-82fb-60909f5b8d93" />
<img width="440" height="506" alt="Damaged Image" src="https://github.com/user-attachments/assets/3f0eb370-8be1-4a2d-89b9-a188cb3d09c2" />


## 文字检测（Detection）与识别（Classification）

### 传统方法

结构特征/静态特征工程，如Two-Level Classification (TLC)、Graph Isomorphism Recognition (GIR)、Line Feature Recognition (LFR)；霍夫变换、高斯滤波；尺度不变特征变换（SIFT）算法提取鲁棒关键点……；Tao等人(2025)提出一种基于聚类(clustering)的特征空间表征学习方法，使用不同甲骨文字形实例作为先验知识。

<img width="726" height="219" alt="Pasted Graphic 13" src="https://github.com/user-attachments/assets/c9453d72-6885-4f43-bad4-9b1fc438154d" caption="Tao et al. (2025)" />

### 深度学习方法

使用CNN、VGG、注意力聚合（Attention Aggregation）、ViT、Graph Transformer等。早期工作如OracleNet、Li等人(2018)基于两阶段特征映射的神经网络识别青铜器铭文，Top-10准确率达94.2%。Mai等人(2024)提出基于Inception模块和残差连接的新型CNN架构，在Oracle-MNIST上达到95.93%准确率。Jing等人(2024)提出了增强的深度学习框架，集成了IntraCL模块、自适应特征金字塔和精细化损失函数，显著提高了在噪声和密集书写简牍中的检测准确性。陈明等人(2025)提出轻量级QBSC Transformer，采用可分离卷积与窗口自注意力机制融合，在秦简文字识别上达到99.46%准确率，参数量仅12.7M。

### 集成学习策略

陈超等人(2025)提出基于深度集成学习（MobileNet + Xception + InceptionV3 + ResNet50）的楚系简帛文字识别方法，使用四种深度网络提取共同形态学特征，准确率达96.72%。王泽鑫等人(2025)改进基于ViT和ResNet的Stacking集成甲骨文识别模型，在临摹和拓片识别上分别达到83%和81%准确率。

### 零样本学习

刘宗昊等人(2024)提出语义增强的零样本甲骨文识别方法，通过提示学习提取字符语义，性能提升超过25%。
<img width="727" height="558" alt="Pasted Graphic 66" src="https://github.com/user-attachments/assets/77e658f8-d6a9-4629-8575-a80fe0838079" />


## 文字破译/释读（Decipherment）

### 基于扩散模型的破译

- Guan等人(ACL 2024 Best Paper)提出Oracle Bone Script Decipher (OBSD)，采用条件扩散策略，结合局部-整体结构约束、风格调优生成破译线索。

<img width="718" height="395" alt="Training" src="https://github.com/user-attachments/assets/b26dd68b-93ae-4092-92cc-0312bd171f69" />
<img width="422" height="437" alt="OBS" src="https://github.com/user-attachments/assets/19b4a59e-d9fc-4638-b5f1-41db2b2b9639" />
<img width="445" height="388" alt="Figure 10 Deciphered results for genuine undeciphered" src="https://github.com/user-attachments/assets/138ec17b-5352-4b3c-a855-b5bd032852d8" />

- Li等人(2025)的OracleFusion利用多模态大语言模型和结构化语义字体（semantic typography）设计，使用多模态大模型生成自然语言笔画结构分析，引入笔画结构约束（glyph constraints）生成富语义的矢量字体图片，从而辅助专家破译文字——然而高度依赖模型先验知识，生成的字形解释和图片往往在已释文字上贻笑大方。

<img width="992" height="738" alt="Pasted Graphic 35" src="https://github.com/user-attachments/assets/3220872d-2b8c-42c6-ae2f-71e6eea39046" />

> 如第一例“赤”，本从“大”“火”会意，系统生硬地构造出“火上烤人”之解，更不谈与“赤”有何关联，笔者虽受古文字学训练极浅，亦不甚认同。

<img width="962" height="541" alt="Pasted Graphic 36" src="https://github.com/user-attachments/assets/c7b0488f-1635-42f1-a515-21b37304adc3" />


### 跨字体检索

Wu等人(2024)提出跨字体图像检索网络(CFIRN)，通过建立甲骨文与其他字体形式的关联来辅助破译。

<img width="483" height="500" alt="QUANTITATIVE RESULT FOR THE PROPOSED CFIRN FOR DIFFERENT" src="https://github.com/user-attachments/assets/e0396349-1b5e-470e-9c65-c2ca60f0855a" />


### 部首重构方法

- Wang等人(2024)的Puzzle Pieces Picker (P³)将甲骨文解构为基础笔画和部首，通过Transformer模型重构为现代对应字符。

<img width="676" height="262" alt="Fig  2  The decipherment of ancient Chinese characters is treated as a puzzle-solving" src="https://github.com/user-attachments/assets/274d162b-855e-452b-8385-20f2f57f0f67" />
<img width="618" height="418" alt="108 B850" src="https://github.com/user-attachments/assets/b8ddc431-2289-471e-af90-a4c39269fec9" />
<img width="770" height="663" alt="simulated undeciphered characters" src="https://github.com/user-attachments/assets/9ff870d0-1b1e-45fb-8535-5e41a2d4f649" />


- Shi等人(2025)的CoLa模型学习中文字符的组合潜在成分（compositional latent components），通过在潜在空间中比对这些成分来实现零样本字符识别。

<img width="1069" height="529" alt="Compositional" src="https://github.com/user-attachments/assets/57c1c152-5c91-40d5-9b4d-6decbbddf78b" />
<img width="929" height="539" alt="call -" src="https://github.com/user-attachments/assets/9ac182e2-d82b-44f4-88c8-10579942c567" />
<img width="456" height="581" alt="15) 1" src="https://github.com/user-attachments/assets/c888dc1e-6711-447a-b918-f55e77b6490d" />
<img width="966" height="282" alt="Pasted Graphic 17" src="https://github.com/user-attachments/assets/0e18dda1-d05f-4a2e-a00f-ca135ad19e98" />

- Peng等人(2025)采用大视觉语言模型（LVLM）+部首标签+象形自然语言分析的融合方法，构建了相关数据。

<img width="966" height="416" alt="Pasted Graphic 27" src="https://github.com/user-attachments/assets/2c0af1a2-f62b-4152-8173-976788060390" />
<img width="951" height="591" alt="Pasted Graphic 28" src="https://github.com/user-attachments/assets/f4c1ab9b-5524-429e-95ae-b1c312814c87" />


### 多模态方法

Jiang等人(2024)的OracleSage框架集成了层次化视觉理解（Hierarchical Visual-Semantic Understanding）和基于图的语义推理（Graph-based Semantic Reasoning），利用了视觉和自然语言描述双模态信息，构建类知识图谱的视觉-部件-语义图结构，最终以自然语言描述的方式尝试破译。

<img width="893" height="269" alt="Pasted Graphic 38" src="https://github.com/user-attachments/assets/5ba005e6-58e5-4d24-a4c5-a8378ae8063d" />
<img width="671" height="493" alt="Description" src="https://github.com/user-attachments/assets/06c48c54-ca73-4431-9ef2-093d117d1698" />


## 辅助任务与应用

---

> 这里事实上违背了开头对文章范围的限制，然下述两篇Google DeepMind Nature在古文字智能研究中影响力过于重大，故破例提及。

Assael等人在Nature发表的两篇里程碑式论文标志着AI古文字研究进入新阶段。

2022年的Ithaca系统专门用于古希腊铭文的文本修复、地理归属和年代确定，采用基于Transformer的序列到序列架构，结合地理和时间嵌入，单独使用时文本修复准确率达62%，与历史学家协作时准确率从25%提升至72%，展现了人机协作的巨大潜力。

<img width="512" height="300" alt="Characters" src="https://github.com/user-attachments/assets/52bf1bbb-f282-4412-8a91-e0e265137ce7" />


2025年的Aeneas系统在技术上实现了重大突破：(1) **生成式神经网络架构**：采用基于注意力机制的编码器-解码器结构，能够处理任意长度的文本修复任务；(2) **多模态融合**：整合视觉输入（铭文图像）和文本信息，通过跨模态注意力机制实现更精准的语境理解；(3) **并行检索机制**：同时检索文本和语境相似的铭文，利用共享短语、功能或文化背景建立历史关联；(4) **渐进式修复策略**：从局部到全局逐步完善文本修复，避免错误传播。

<img width="706" height="414" alt="Pasted Graphic 19" src="https://github.com/user-attachments/assets/b8dedc73-3d50-4d65-9388-c72df198b45a" />


在实际应用中，Aeneas在90%的案例中为历史学家提供了有用的研究起点，将专家在关键任务中的信心提升44%。在文本修复和地理归属任务中，人机协作模式显著优于单独的人工或AI方法。在年代确定任务中，Aeneas实现了与真实年代范围仅13年的误差。

---

### 缀合（Rejoining）与校重（Deduplication）

- Zhang等人引入了OB-Rejoin数据集，并开发了基于孪生网络的碎片匹配方法，实现了80.9%的重组准确率，从而将甲骨文识别的应用扩展到物理修复领域。
- 张重生等人(2023)基于斜率变化量序列相似性和字符序列模糊匹配计算提出甲骨缀合算法SUM，Top-15缀合召回率达95.18%。

<img width="782" height="538" alt="Pasted Graphic 59" src="https://github.com/user-attachments/assets/e2e31eaa-d43d-45b4-8424-4c922cd8088c" />

- Zhang等人(2025)设计渐进式甲骨重复发现框架OBD-Finder，结合无监督关键点匹配和高层次文本内容匹配，兼顾语义感知和可解释性，并成功发现10组全新甲骨重片。

<img width="820" height="673" alt="Layer #N" src="https://github.com/user-attachments/assets/7d2e931e-dbe0-49b6-af1b-c30ec21b832c" />
<img width="904" height="479" alt="Pasted Graphic 24" src="https://github.com/user-attachments/assets/e06ca865-535f-4149-a868-b2ec4ff07621" />


- 李霜洁(2024)运用"知微缀"系统，以人工智能引导人类直觉的交互方式，以颜色表征和刺激这一新的可视化分析方法提高专家信息认知效率，发现一系列新的甲骨缀合。
<img width="542" height="474" alt="Pasted Graphic 56" src="https://github.com/user-attachments/assets/881201ac-9734-4c98-b545-07f27fa90ea5" />


- Zhu等人(2025)提出WisePanda，一个物理驱动的深度学习框架，用于竹简残片缀合，Top-50匹配准确率从36%提升至52%，效率提升约20倍。
<img width="819" height="508" alt="Pasted Graphic 45" src="https://github.com/user-attachments/assets/b87c590f-1cf6-48da-9d5b-089fd7e0bfe6" />
<img width="705" height="725" alt="Pasted Graphic 46" src="https://github.com/user-attachments/assets/6e89aaae-0f3a-4e16-b4b7-aac3c0b2ba0b" />



### 智能问答

熊晶等人(2023)基于"殷契文渊"平台构建甲骨文知识图谱和智能问答系统，基于Cypher查询语言满足基础知识查询需求。

### 断代与分类

Zhou等人(2023)基于知识引导关系图实现中国青铜鼎的多粒度考古断代。文字变体聚类方面，Liu等人(2021)结合ResNet50特征提取和谱聚类来自动分组视觉相似的字形变体。

### 分词（Segmentation/Tokenization）与语言建模


- Hu等人(2025)基于专家预定义的笔画规则，提出了甲骨文部件划分新任务；
<img width="1001" height="619" alt="highlighted in red  GT repeesents the ground truth annotations" src="https://github.com/user-attachments/assets/b6524c48-da47-4d54-88dc-b0ef7eac3fbf" />

- Cao等人(2022)针对楚简识别中笔画重叠、墨水分布不均和背景噪声等问题，引入了局部自适应阈值方法，使用有效字符轮廓长度（ECCL）度量和多高斯拟合来确定划分的最优阈值；
- Chen等人(2024)设计楚系简帛文字多模态多粒度分词器（tokenizer），将检测到的简帛字形对应到当代字形或拆分为子字（sub-character）；

<img width="430" height="602" alt="Sub-characters" src="https://github.com/user-attachments/assets/0790b396-356d-458b-afc8-b3aace14a1a6" />


- Diao等人(2025)提出InteChar统一字符列表，整合未编码甲骨文字符与传统现代中文，为古代中文语言建模奠定基础，实验表明在InteChar上训练的模型在理解任务中有显著性能提升。

<img width="974" height="311" alt="Pasted Graphic 25" src="https://github.com/user-attachments/assets/0ea31e0f-4a35-4754-ad5e-0db33e47b8d9" />



### 大语言模型应用

- Chen等人(2025)的OBI-Bench评估大型多模态模型在甲骨文全流程（recognition, rejoining, classification, retrieval, and deciphering）处理任务中的表现，结果表明当前多模态大模型只能勉强达到未经训练人类水平。

<img width="758" height="489" alt="OBI-Bench PA" src="https://github.com/user-attachments/assets/e3583276-0347-4a67-8863-1c21218e3fad" />
<img width="758" height="307" alt="Figure 2 Sampled OBI-Bench examples from each task  5,523 (I, Q, A) tuples span two quadrants" src="https://github.com/user-attachments/assets/bd7e9fd1-33ce-4f68-aea7-e9ff17216643" />


- Qiao等人(2025)的V-Oracle框架将甲骨文破译框架化为视觉问答问题，建立多步、多层次推理链，实施了多阶段的对齐和微调，在自建数据的古文字破译和解释两个任务上优势显著。

<img width="890" height="411" alt="Pasted Graphic 53" src="https://github.com/user-attachments/assets/1d839ff5-c047-4f65-8dc4-a39300853817" />
<img width="927" height="486" alt="Figure 5 Overview of our Oracle Alignment Tuning, Left The multi-stage training process of V-Oracle  Right" src="https://github.com/user-attachments/assets/60956fcf-fc31-488e-84e0-29bcbb6ebf28" />
<img width="882" height="521" alt="Pasted Graphic 55" src="https://github.com/user-attachments/assets/bba031b0-8f8f-4585-a914-4dc200c6245a" />


### 古文字知识图谱

- 李春桃等人(2023)讨论了古文字知识图谱的架构，以及利用知识图谱开展相似古文字量化研究。
<img width="469" height="393" alt="Pasted Graphic 57" src="https://github.com/user-attachments/assets/54084a08-b648-4972-af11-88b1da0f370c" />
<img width="499" height="382" alt="Pasted Graphic 58" src="https://github.com/user-attachments/assets/c2f0a0bd-100a-4224-a437-2080d30ef4b4" />


- 李霜洁(2021)运用图论中的完全图来交叉确定甲骨卜辞贞人共时关系网络，从61043版殷墟甲骨材料中(统计数值为经过去重及缀合后的结果)，整理出卜辞里不同贞人共版的原始材料共计828版，涉及贞人名55个，共版关系139对，分布于师、宾、出、何这4个贞人组中。为了充分挖掘贞人之间的共版关系，构建图模型来表示这种网络关系，并将其可视化，绘制了"甲骨卜辞贞人共版网络图"及"甲骨卜辞贞人共版矩阵-热图"。
<img width="731" height="605" alt="Pasted Graphic 65" src="https://github.com/user-attachments/assets/a2140619-f2ac-4358-a1df-aa743f353480" />
<img width="700" height="695" alt="image" src="https://github.com/user-attachments/assets/05aa5f67-e917-455e-b6e2-5610dcee602e" />


### 古文字文献整理

李霜洁等人(2024)基于"支點(LeverX)"古文字文献数智整理系统，融合文本-图像(语言-视觉)多模态信息，推出甲骨命名实体标注(Jiagu Named Entity Annotation)、贞卜焦点标注(Divinatory Focus Annotation)、刻辞部位可视化(Inscription Layout Visualization)、辞兆关系图(Inscription-Crack Graph)、辞际关系图(Inscription Mapping Graph)等多种面向甲骨文重点疑难问题的全新体例，提高原有的速度和减少重复劳动，有利于研究者将工作重心专注于深化内容、提升品质与拓展学术洞察。

<img width="841" height="619" alt="Pasted Graphic 60" src="https://github.com/user-attachments/assets/5414c6a0-577e-4277-ac90-fd142c6cf576" />
<img width="847" height="637" alt="Pasted Graphic 61" src="https://github.com/user-attachments/assets/1c743713-c684-49a9-bf55-c3b074022447" />
<img width="827" height="530" alt="449" src="https://github.com/user-attachments/assets/16305259-2951-4d11-a35f-36a9be8f19c0" />
<img width="721" height="516" alt="Pasted Graphic 63" src="https://github.com/user-attachments/assets/5eb29838-2c80-4754-b315-670736be8549" />
<img width="500" height="611" alt="Pasted Graphic 64" src="https://github.com/user-attachments/assets/820ff63a-184a-4df1-9d96-d8af86fef23b" />


## 研究现状与问题

**机构分布**：研究主要集中在复旦大学、华中科技大学（甲骨文）、安阳师范学院（甲骨文）、清华大学（简帛）、吉林大学（金文）等高校，以及腾讯、字节跳动等机构，体现出明显的地域专业特色和产研共生属性。

**数据分布不均**：甲骨文研究十分活跃，数据集和方法较为丰富；简帛文字研究次之；金文研究相对稀少。

**技术挑战**：
1. 数据稀缺性：古文字样本有限，长尾分布严重
2. 图像质量：拓片噪声、字型变体多、残缺不全
3. 语义理解：缺乏大规模语料，语义信息匮乏，需要融合外部知识
4. 跨域泛化：不同时期、不同载体文字差异大

<img width="365" height="424" alt="Figure 2 Illustration of writing variability  Samples differ-" src="https://github.com/user-attachments/assets/ac7b1223-a5a4-42e7-b286-d9fda28011b7" />
<img width="432" height="135" alt="Pasted Graphic 6" src="https://github.com/user-attachments/assets/5ba9377e-68e9-4e8a-b53f-e349e1965e90" />
<img width="626" height="275" alt="Figure 3 Class distributions in two oracle datasets, a) OBC306  1  b) Oracle-AYNU  2)" src="https://github.com/user-attachments/assets/98fd2c18-6cf6-4655-a0ba-b826f94fb69b" />
<img width="421" height="297" alt="Figure 4 Examples of oracle data  Isolated scanned characters (a)" src="https://github.com/user-attachments/assets/e35b3beb-6473-4eaf-aa05-3942bfac53f1" />


**发展趋势**：
1. 从单一识别向多任务学习发展
2. 从监督学习向零样本、少样本学习转变
3. 从纯视觉方法向多模态融合演进
4. 从自动化处理向人机协作模式发展

研究呈现出**问题导向、专家知识密集、技术密集**的特点，往往需要**大规模、高水平、跨学科**团队。古文字研究是“形、音、义、例”灵活运用的复杂推理分析过程，目前大部分的AI for 古文字研究在**尊重古文字学学科传统、知识和经验**上存在较大缺陷，并且较大程度上拘泥于“形”和“义”两个层面的智能处理，对于“音”和“辞例”（文献）的关注不足。由于古文字的上古音构拟挑战巨大，我们不妨可以从文献入手，瞄准模糊搜索、文献智能分析、知识灵活问答等方向，打造面向时代新要求的古文字学研究基础设施。

## 参考文献

```
Assael, Y., Sommerschield, T., Cooley, A., Shillingford, B., Pavlopoulos, J., Suresh, P., Herms, B., Grayston, J., Maynard, B., Dietrich, N., Wulgaert, R., Prag, J., Mullen, A., & Mohamed, S. (2025). Contextualizing ancient texts with generative neural networks. Nature, 645(8079), 141–147. https://doi.org/10.1038/s41586-025-09292-5
Assael, Y., Sommerschield, T., Shillingford, B., Bordbar, M., Pavlopoulos, J., Chatzipanagiotou, M., Androutsopoulos, I., Prag, J., & De Freitas, N. (2022). Restoring and attributing ancient texts using deep neural networks. Nature, 603(7900), 280–283. https://doi.org/10.1038/s41586-022-04448-z
Cao, S., Shu, Z., Xu, Z., Xie, D., & Xu, Y. (2022). Character segmentation and restoration of Qin-Han bamboo slips using local auto-focus thresholding method. Multimedia Tools and Applications, 81(6), 8199–8213. https://doi.org/10.1007/s11042-022-11988-z
Chen, Y., Hu, C., Feng, C., Song, C., Yu, S., Han, X., Liu, Z., & Sun, M. (2024). Multi-Modal Multi-Granularity Tokenizer for Chu Bamboo Slip Scripts (No. arXiv:2409.01011). arXiv. https://doi.org/10.48550/arXiv.2409.01011
Chen, Z., Chen, T., Zhang, W., & Zhai, G. (2025). OBI-Bench: Can LMMs Aid in Study of Ancient Script on Oracle Bones? (No. arXiv:2412.01175). arXiv. https://doi.org/10.48550/arXiv.2412.01175
Chen, Z., Hua, W., Li, J., Deng, L., Du, F., Chen, T., & Zhai, G. (2025). PictOBI-20k: Unveiling Large Multimodal Models in Visual Decipherment for Pictographic Oracle Bone Characters (No. arXiv:2509.05773). arXiv. https://doi.org/10.48550/arXiv.2509.05773
Diao, X., Bo, R., Xiao, Y., Shi, L., Zhou, Z., Xu, H., Li, C., Tang, X., Poesio, M., John, C. M., & Shi, D. (2025). Ancient Script Image Recognition and Processing: A Review (No. arXiv:2506.19208). arXiv. https://doi.org/10.48550/arXiv.2506.19208
Diao, X., Zhou, Z., Shi, L., Wang, T., Qi, R., Xu, H., & Shi, D. (2025). InteChar: A Unified Oracle Bone Character List for Ancient Chinese Language Modeling (No. arXiv:2508.15791). arXiv. https://doi.org/10.48550/arXiv.2508.15791
Duan, S., Wang, J., & Su, Q. (2024). Restoring Ancient Ideograph: A Multimodal Multitask Neural Network Approach (No. arXiv:2403.06682). arXiv. https://doi.org/10.48550/arXiv.2403.06682
Guan, H., Wan, J., Liu, Y., Wang, P., Zhang, K., Kuang, Z., Wang, X., Bai, X., & Jin, L. (2024). An open dataset for the evolution of oracle bone characters: EVOBC (No. arXiv:2401.12467). arXiv. https://doi.org/10.48550/arXiv.2401.12467
Guan, H., Yang, H., Wang, X., Han, S., Liu, Y., Jin, L., Bai, X., & Liu, Y. (2025). Deciphering Oracle Bone Language with Diffusion Models (No. arXiv:2406.00684). arXiv. https://doi.org/10.48550/arXiv.2406.00684
Hu, Z., Cheung, Y., Zhang, Y., Peiying, Z., & Ling, T. P. (n.d.). Component-Level Segmentation for Oracle Bone Inscription Decipherment.
Huang, H., Yang, D., Dai, G., Han, Z., Wang, Y., Lam, K.-M., Yang, F., Huang, S., Liu, Y., & He, M. (2023). AGTGAN: Unpaired Image Translation for Photographic Ancient Character Generation (No. arXiv:2303.07012). arXiv. https://doi.org/10.48550/arXiv.2303.07012
Jiang, H., Pan, Y., Chen, J., Liu, Z., Zhou, Y., Shu, P., Li, Y., Zhao, H., Mihm, S., Howe, L. C., & Liu, T. (2024). OracleSage: Towards Unified Visual-Linguistic Understanding of Oracle Bone Scripts through Cross-Modal Knowledge Fusion (No. arXiv:2411.17837). arXiv. https://doi.org/10.48550/arXiv.2411.17837
Jing, B., Chen, B., Chen, H., & Tan, J. (2024). Method for Qin Bamboo Slip Text Detection Based on an Enhanced DBNet Model. 2024 4th International Symposium on Artificial Intelligence and Intelligent Manufacturing (AIIM), 952–958. https://doi.org/10.1109/AIIM64537.2024.10934214
Li, B., Luo, D., Liang, Y., Yang, J., Ding, Z., Peng, X., Jiang, B., Han, S., Sui, D., Qin, P., Wu, P., Wang, C., Qi, Y., Jin, T., Wang, C., Huang, X., Shu, Z., Ji, R., Liu, Y., & Wu, Y. (2024). Oracle Bone Inscriptions Multi-modal Dataset (No. arXiv:2407.03900). arXiv. https://doi.org/10.48550/arXiv.2407.03900
Li, C., Ding, Z., Hu, X., Li, B., Luo, D., Wu, A., Wang, C., Wang, C., Jin, T., SevenShu, Wu, Y., Liu, Y., & Ji, R. (2025). OracleFusion: Assisting the Decipherment of Oracle Bone Script with Structurally Constrained Semantic Typography (No. arXiv:2506.21101). arXiv. https://doi.org/10.48550/arXiv.2506.21101
Li, J., Chen, Z., Chen, T., Liu, Z., & Wang, C. (2025). OBIFormer: A Fast Attentive Denoising Framework for Oracle Bone Inscriptions (No. arXiv:2504.13524). arXiv. https://doi.org/10.48550/arXiv.2504.13524
Li, J., Chen, Z., Jiang, R., Chen, T., Wang, C., & Zhai, G. (2025). Mitigating Long-tail Distribution in Oracle Bone Inscriptions: Dataset, Model, and Benchmark (No. arXiv:2504.09555). arXiv. https://doi.org/10.48550/arXiv.2504.09555
Li, J., Chi, X., Wang, Q., Wang, D., Huang, K., Liu, Y., & Liu, C. (2024). A comprehensive survey of oracle character recognition: Challenges, benchmarks, and beyond (No. arXiv:2411.11354). arXiv. https://doi.org/10.48550/arXiv.2411.11354
Li, J., Wang, Q.-F., Wang, S., Zhang, R., Huang, K., & Cambria, E. (2024). Diff-Oracle: Deciphering Oracle Bone Scripts with Controllable Diffusion Model (No. arXiv:2312.13631). arXiv. https://doi.org/10.48550/arXiv.2312.13631
Liu, G., Ge, W., & Du, B. (2021). Recognition of OBIC’s Variants by Using Deep Neural Networks and Spectral Clustering. 2021 IEEE 4th International Conference on Information Systems and Computer Aided Education (ICISCAE), 39–42. https://doi.org/10.1109/ICISCAE52414.2021.9590692
Mai, C., Penava, P., & Buettner, R. (2024). Oracle Bone Inscription Character Recognition Based on a Novel Convolutional Neural Network Architecture. IEEE Access, 12, 197021–197034. https://doi.org/10.1109/ACCESS.2024.3521319
Peng, K., Zhao, M., Yu, H., Fu, T., & Li, B. (2025). Interpretable Oracle Bone Script Decipherment through Radical and Pictographic Analysis with LVLMs (No. arXiv:2508.10113). arXiv. https://doi.org/10.48550/arXiv.2508.10113
Qi, H., Yang, H., Wang, Z., Ye, J., Xin, Q., Zhang, C., & Lang, Q. (2025). AncientGlyphNet: An advanced deep learning framework for detecting ancient Chinese characters in complex scene. Artificial Intelligence Review, 58(3), 88. https://doi.org/10.1007/s10462-024-11095-5
Qiao, R., Tan, Q., Dong, G., MinhuiWu, M., Wang, J., Zhang, Y., GongQue, Z., Sun, C., Xu, Y., Xue, Y., Tian, Y., Bao, Z., Yang, L., Li, C., & Zhang, H. (2025). V-Oracle: Making Progressive Reasoning in Deciphering Oracle Bones for You and Me. In W. Che, J. Nabende, E. Shutova, & M. T. Pilehvar (Eds.), Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers) (pp. 20124–20150). Association for Computational Linguistics. https://doi.org/10.18653/v1/2025.acl-long.986
Shi, F., Yu, H., Li, B., & Xue, X. (2025). CoLa: Chinese Character Decomposition with Compositional Latent Components (No. arXiv:2506.03798). arXiv. https://doi.org/10.48550/arXiv.2506.03798
Tao, Y., Fu, X., Pang, H., Yang, X., & Li, C. (2025). Clustering-based Feature Representation Learning for Oracle Bone Inscriptions Detection (No. arXiv:2508.18641). arXiv. https://doi.org/10.48550/arXiv.2508.18641
Wang, M., Deng, W., & Liu, C.-L. (2022). Unsupervised Structure-Texture Separation Network for Oracle Character Recognition. IEEE Transactions on Image Processing, 31, 3137–3150. https://doi.org/10.1109/TIP.2022.3165989
Wang, P., Zhang, K., Wang, X., Han, S., Liu, Y., Jin, L., Bai, X., & Liu, Y. (2024). Puzzle Pieces Picker: Deciphering Ancient Chinese Characters with Radical Reconstruction (No. arXiv:2406.03019). arXiv. https://doi.org/10.48550/arXiv.2406.03019
Wang, P., Zhang, K., Wang, X., Han, S., Liu, Y., Wan, J., Guan, H., Kuang, Z., Jin, L., Bai, X., & Liu, Y. (2024). An open dataset for oracle bone character recognition and decipherment. Scientific Data, 11(1), 976. https://doi.org/10.1038/s41597-024-03807-x
Wu, X., Wang, Z., & Ren, P. (2022). CNN-based Bronze Inscriptions Character Recognition. 2022 5th International Conference on Advanced Electronic Materials, Computers and Software Engineering (AEMCSE), 514–519. https://doi.org/10.1109/AEMCSE55572.2022.00106
Wu, Z., Su, Q., Gu, K., & Shi, X. (2024). A Cross-Font Image Retrieval Network for Recognizing Undeciphered Oracle Bone Inscriptions (No. arXiv:2409.06381). arXiv. https://doi.org/10.48550/arXiv.2409.06381
Xu, Y., Wang, X., Guo, S., & Yu, J. (2025). Chinese-Seal Dataset(Csd): Diverse Attributes for Seal Detection, Segmentation and Recognition (SSRN Scholarly Paper No. 5079459). Social Science Research Network. https://doi.org/10.2139/ssrn.5079459
Yalin, M., Li, L., Yichun, J., & Guodong, L. (2022). Research on denoising method of chinese ancient character image based on chinese character writing standard model. Scientific Reports, 12(1), 19795. https://doi.org/10.1038/s41598-022-24388-y
Zhang, C., Wu, S., Chen, Y., Men, Y., Fan, G., Aßenmacher, M., Heumann, C., & Gama, J. (2025). Explainable Coarse-to-Fine Ancient Manuscript Duplicates Discovery (No. arXiv:2505.03836). arXiv. https://doi.org/10.48550/arXiv.2505.03836
Zhou, R., Wei, J., Zhang, Q., Qi, R., Yang, X., & Li, C. (2023). Multi-Granularity Archaeological Dating of Chinese Bronze Dings Based on a Knowledge-Guided Relation Graph. 2023 IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR), 3103–3113. https://doi.org/10.1109/CVPR52729.2023.00303
Zhu, J., Zhao, Z., Lei, H., Wang, X., Lu, J., Li, J., Tang, Q., Shen, J., Xia, G.-S., Du, B., & Xu, Y. (2025). Rejoining fragmented ancient bamboo slips with physics-driven deep learning (No. arXiv:2505.08601). arXiv. https://doi.org/10.48550/arXiv.2505.08601
刘宗昊, 彭文杰, 代港, 黄双萍, & 刘永革. (2024). 语义增强的零样本甲骨文字符识别. 电子学报, 52(10), 3347–3358.
张重生 & 王斌. (2023). 基于序列相似性计算的甲骨残片缀合算法. 电子学报, 51(4), 860–869.
李文英, 曹斌, 曹春水, & 黄永祯. (2018). 一种基于深度学习的青铜器铭文识别方法. 自动化学报, 44(11), 2023–2030. https://doi.org/10.16383/j.aas.2018.c180152
李春桃, 张骞, 徐昊, & 高嘉英. (2023). 基于人工智能技术的古文字研究. 吉林大学社会科学学报, 63(2), 164–173, 238–239. https://doi.org/10.15939/j.jujsse.2023.02.wx2
李真黎. (2025). 古文字字形工具书的数字化编辑——以《古文字构形类纂·金文卷》为例. 编辑学刊, 4, 64–68. https://doi.org/CNKI:SUN:BJXZ.0.2025-04-012
李霜洁. (2021). 殷墟卜辞中的贞人网络——兼论运用图论中的完全图来交叉确定多人共时关系. 出土文献, 4, 44–58, 155. https://doi.org/CNKI:SUN:CUWX.0.2021-04-005
李霜洁. (2024). 人工智能引导人类直觉产生的甲骨新缀第21—30组. 出土文献, 2, 17–23, 168–169. https://doi.org/CNKI:SUN:CUWX.0.2024-02-003
李霜潔, 蔣玉斌, 王子楊, 劉知遠, & 孫茂松. (2024). 數智增强的古文字文獻新整理:以殷墟花園莊東地甲骨刻辭爲例. 中国古典学, 5(1), 67–86. https://doi.org/CNKI:SUN:GUDX.0.2024-01-007
汪思文 & 林泽强. (2025). 基于元学习对缺损甲骨文字体的预测. 计算机与数字工程, 53(7), 1999–2003. https://doi.org/CNKI:SUN:JSSG.0.2025-07-036
熊晶, 刘永革, 韩胜伟, & 高峰. (2023). 基于知识图谱的甲骨文智能问答系统. 信息技术与信息化, 5, 212–216. https://doi.org/CNKI:SUN:SDDZ.0.2023-05-057
王泽鑫 & 童恒建. (2025). 基于深度学习的甲骨文图像检测与识别创新应用与改进研究. 软件导刊, 1–11. https://doi.org/10.11907/rjdk.251006 (Advance online publication)
陈明, 陈炳权, & 夏蓉. (2025). 基于轻量级Transformer模型的秦简文字识别算法. 计算机仿真, 42(4), 459–467.
陈超, 李赫孜, & 杨泽坤. (2025). 基于深度集成学习的战国楚系简帛文字识别. 数字人文研究, 5(2), 45–58. https://doi.org/CNKI:SUN:SZYH.0.2025-02-004
```

> Acknowledgement: Accomplished with PKUDH.
