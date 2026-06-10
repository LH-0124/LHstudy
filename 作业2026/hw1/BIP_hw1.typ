#import "@local/tplt:0.2.0": *

#show: BL.with(is-table-cell-stroked: false)
#let ymd = "today"
#let course = "《生物医学图像处理》"
#let proj-name = "Homework 1"

#show: HW.with(
  course: course,
  proj-name: proj-name,
  english: false,
  ymd: ymd,
)

#problem(1)[
  2D Spatial Affine Transform

• Triangle A has vertices at $A_1(0,0), A_2(2,0), A_3(0,1)$. 

• Triangle B has vertices at $B_1(2,1), B_2(2,5), B_3(3,1)$.

Tasks:

• Design a sequence of 3x3 affine transformation matrices(homogeneous 
coordinates).

• 1. Define the matrices for Scaling (S), Rotation (R), and Translation (T) 
(Order: S -> R -> T).

• 2. Calculate the overall transformation matrix $M = T * R * S$.
]
#SOLUTION

1. 三角形A中，$arrow(A_1A_2)=(2,0)$，三角形B中，$arrow(B_1B_2)=(0,4)$。
由此可以看出在三角形A仿射变换到三角形B的过程中三角形A需要在$x$轴方向放大两倍，并且绕原点逆时针旋转90°

三角形A中，$arrow(A_1A_3)=(0,1)$，三角形B中，$arrow(B_1B_3)=(1,0)$。
若仅仅逆时针旋转90°，$arrow(B_1B_3)=(-1,0)$，因此还需要在$y$轴经历一次镜像对称，即$y$轴方向缩放-1倍

由此我们可以得到缩放矩阵
$
S=mat(2,0,0;0,-1,0;0,0,1)
$
旋转矩阵
$
R=mat(cos 90,-sin 90,0;sin 90,cos 90,0;0,0,1)=mat(0,-1,0;1,0,0;0,0,1)
$

原点$A_1(0,0)$变换后为$B_1(2,1)$因此平移了$x$轴正方向两单位，$y$轴正方向1个单位

由此可得平移矩阵
$
T=mat(1,0,2;0,1,1;0,0,1)
$
#pagebreak()
2. 由此
$ M=T*(R*S)=mat(0,1,2;2,0,1;0,0,1) $

验算：
$ mat(0,1,2;2,0,1;0,0,1)mat(0;0;1)=(2,1,1)^T $

$ mat(0,1,2;2,0,1;0,0,1)mat(2;0;1)=(2,5,1)^T $

$ mat(0,1,2;2,0,1;0,0,1)mat(0;1;1)=(3,1,1)^T $

与三角形B坐标一致，所求变换矩阵正确
#pagebreak()
#problem(2)[
  Given two random variables R and Z with the following probability density functions (PDFs):
  - $R$ has a PDF: $p_r (r) = 2-2r$
  - $Z$ has a PDF: $p_z (z) = 3z^2$
  Find the intensity transformation function $z= T(r)$ that maps the original intensity r to the target intensity z, such that the transformed original image matches the target PDF pz(z)
  #figure(image("pics/2.png",width: 50%))
]
#SOLUTION 

计算CDF

$ F_R (r)=integral_0^r (2-2r)d r=2r-r^2,0<=r<=1 $

$ F_Z (z)=integral_0^z 3z^2 d z=z^3 ,0<=z<=1 $

为了使得$r$转换成$z$，则有$p_z (z)=p_r (r) |(d r)/(d z)|$，
即$F_R (r)=F_Z (z)$，则有
$ z=T(r)=root(3,2r-r^2) $

#pagebreak()
#problem(3)[
  Discrete Histogram Equalization & Matching, Given a grayscale image ($L$=8, intensity levels 0–7) with 100 pixels.

  Intensity distribution ($n_k$) for $k$=0 to 7: [40, 20, 15, 10, 5, 5, 3, 2]

  Target probability distribution ($p_z$) for $z$=0 to 7: [0, 0.07, 0.10, 0.26, 0.28, 0.15, 0.11, 0.03]

  1. Perform Histogram Equalization on the original image to find the discrete mapping values $s_k$

  2. Compute the transformation function $G(z)$ for the target histogram.

  3. Perform Histogram Matching to map original intensity $r_k$ to target intensity $z_q$

  – In case of a tie, choose the smaller $z_q$

]
#SOLUTION



已知离散灰度级数 $L = 8$（灰度范围为 $0$ 至 $7$），原始图像总像素数为 $N = 100$。

1. 原始图像第 $k$ 级灰度的出现概率为 $p_r (r_k) = n_k / N$。其直方图均衡化的离散变换函数为：

$ s_k = T(r_k) =  (L - 1) sum_(j=0)^k p_r (r_j) =  7 sum_(j=0)^k p_r (r_j) $

计算结果需要四舍五入，映射为整数。

计算过程如表1所示：

#align(center)[
  #figure(
    caption: [$s_k$计算],
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.header(
        [$r_k$], [$n_k$], [$p_r (r_k)$], [$sum_(j=0)^k p_r (r_j)$], [$7 sum_(j=0)^k p_r (r_j)$], [$s_k$]
      ),
      table.hline(y: 1, stroke: 0.5pt),
      [0], [40], [0.40], [0.40], [2.80], [3],
      [1], [20], [0.20], [0.60], [4.20], [4],
      [2], [15], [0.15], [0.75], [5.25], [5],
      [3], [10], [0.10], [0.85], [5.95], [6],
      [4], [5],  [0.05], [0.90], [6.30], [6],
      [5], [5],  [0.05], [0.95], [6.65], [7],
      [6], [3],  [0.03], [0.98], [6.86], [7],
      [7], [2],  [0.02], [1.00], [7.00], [7],
      table.hline(y: 9, stroke: 1pt)
    )
  )
]

2. 

目标图像第 $q$ 级灰度的规定概率为 $p(z_q)$。对其求累积分布并进行量化，得到变换函数 $G(z)$。

$ G(z) = (L - 1) sum_(j=0)^q P(z_j) =  7 sum_(j=0)^q P(z_j) $

计算结果需要四舍五入，映射为整数。

计算过程如表2所示：

#align(center)[
  #figure(
    caption: [$G(z_q)$计算],
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.header(
        [$z_q$], [$P(z_q)$], [$sum_(j=0)^q P(z_j)$], [$7 sum_(j=0)^q P(z_j)$], [$G(z_q)$]
      ),
      table.hline(y: 1, stroke: 0.5pt),
      [0], [0.00], [0.00], [0.00], [0],
      [1], [0.07], [0.07], [0.49], [0],
      [2], [0.10], [0.17], [1.19], [1],
      [3], [0.26], [0.43], [3.01], [3],
      [4], [0.28], [0.71], [4.97], [5],
      [5], [0.15], [0.86], [6.02], [6],
      [6], [0.11], [0.97], [6.79], [7],
      [7], [0.03], [1.00], [7.00], [7],
      table.hline(y: 9, stroke: 1pt)
    )
  )
]

3. 

直方图匹配的原则是对于每个 $s_k$，在表2中寻找满足 $|G(z_q) - s_k|$ 最小的 $z_q$。依据题意，若出现差值相等的情况，选取较小的 $z_q$。

- 当 $s_0 = 3$ 时，对应 $G(3) = 3$，故 $r_0 -> z_3 = 3$。
- 当 $s_1 = 4$ 时，$G(3)=3$ 与 $G(4)=5$ 的绝对差值均为 1。取较小值，故 $r_1 -> z_3 = 3$。
- 当 $s_2 = 5$ 时，对应 $G(4) = 5$，故 $r_2 -> z_4 = 4$。
- 当 $s_3 = 6$ 时，对应 $G(5) = 6$，故 $r_3 -> z_5 = 5$。
- 当 $s_4 = 6$ 时，对应 $G(5) = 6$，故 $r_4 -> z_5 = 5$。
- 当 $s_5 = 7$ 时，对应 $G(6)=7$ 及 $G(7)=7$。取较小值，故 $r_5 -> z_6 = 6$。
- 同理，$s_6 = 7, s_7 = 7$ 均映射至 $z_6 = 6$。即$r_6 -> z_6 = 7,r_7 -> z_6=7$

最终的灰度映射关系如表3所示：

#align(center)[
  #figure(
    caption: [最终灰度映射关系表],
    table(
      columns: 3,
      align: center,
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.header(
        [ $r_k$], [ $s_k$], [$z_q$]
      ),
      table.hline(y: 1, stroke: 0.5pt),
      [0], [3], [3],
      [1], [4], [3],
      [2], [5], [4],
      [3], [6], [5],
      [4], [6], [5],
      [5], [7], [6],
      [6], [7], [6],
      [7], [7], [6],
      table.hline(y: 9, stroke: 1pt)
    )
  )
]