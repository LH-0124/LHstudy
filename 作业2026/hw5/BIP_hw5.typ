#import "@local/tplt:0.2.0": *

#show: BL.with(is-table-cell-stroked: false)
#let ymd = "today"
#let course = "《生物医学图像处理》"
#let proj-name = "Homework 5"

#show: HW.with(
  course: course,
  proj-name: proj-name,
  english: false,
  ymd: ymd,
)

#problem(1)[
  对于两幅MRI图像 $A$（固定图像）和 $B'$（浮动图像），如果这两幅图像是对同一主体扫描两次得到的，那么 $A$ 和 $B'$ 之间只存在线性变换，可以表示为：$B'(i) = k A(i) + t, forall i in {m | B'(m) > 0}$。

  证明：
  - $A$ 和 $B'$之间的互相关系数 (CC, Cross-Correlation) 为 1。
  - 使用 $k, t$、总像素数 $N$ 以及 $A$ 的均值/标准差 ($overline(A), sigma(A)$) 来表示 $A$ 和 $B'$ 之间的误差平方和 (SSD, Sum of Squared Differences)。
]

#SOLUTION

  *1. 证明 $A$ 和 $B'$ 之间的 CC 为 1*

  互相关系数 (CC) 的标准计算公式为：
  $ C C(A, B') = (sum_(i=1)^N (A(i) - overline(A))(B'(i) - overline(B'))) / (sqrt(sum_(i=1)^N (A(i) - overline(A))^2) sqrt(sum_(i=1)^N (B'(i) - overline(B'))^2)) $

  已知 $B'(i) = k A(i) + t$，我们可以先求出浮动图像 $B'$ 的均值 $overline(B')$：
  $ overline(B') = 1/N sum_(i=1)^N (k A(i) + t) = k (1/N sum_(i=1)^N A(i)) + 1/N (N t) = k overline(A) + t $

  将 $B'(i)$ 和 $overline(B')$ 代入 CC 公式，首先计算分子：
  $ sum_(i=1)^N (A(i) - overline(A))(k A(i) + t - (k overline(A) + t)) &= sum_(i=1)^N (A(i) - overline(A))(k A(i) - k overline(A)) \
  &= k sum_(i=1)^N (A(i) - overline(A))^2 $

  接着计算分母中的第二项（即 $B'$ 的标准差部分）：
  $ sqrt(sum_(i=1)^N (k A(i) + t - (k overline(A) + t))^2) = sqrt(k^2 sum_(i=1)^N (A(i) - overline(A))^2) = |k| sqrt(sum_(i=1)^N (A(i) - overline(A))^2) $

  因此，整体的互相关系数为：
  $ CC(A, B') = (k sum_(i=1)^N (A(i) - overline(A))^2) / (sqrt(sum_(i=1)^N (A(i) - overline(A))^2) dot |k| sqrt(sum_(i=1)^N (A(i) - overline(A))^2)) = (k sum_(i=1)^N (A(i) - overline(A))^2) / (|k| sum_(i=1)^N (A(i) - overline(A))^2) = k / (|k|) $

  由于图像 $A$ 和 $B'$ 是同一主体的两次扫描，它们的强度应该是正相关的，因此 $k > 0$。所以：
  $ C C(A, B') = 1 $
  

  *2. 使用已知变量表示 SSD*

  误差平方和 (SSD) 的定义为：
  $ S S D(A, B') = 1/N sum_(i=1)^N (A(i) - B'(i))^2 $

  代入 $B'(i) = k A(i) + t$：
  $ S S D(A, B') = 1/N sum_(i=1)^N (A(i) - (k A(i) + t))^2 = 1/N sum_(i=1)^N ((1 - k)A(i) - t)^2 $

  
  $ (1 - k)A(i) - t = (1 - k)(A(i) - overline(A)) + ((1 - k)overline(A) - t) $

  将其代回 SSD 公式并展开平方和 
  $ S S D(A, B') = 1/N sum_(i=1)^N [ (1 - k)^2 (A(i) - overline(A))^2 + 2(1-k)(A(i) - overline(A))((1-k)overline(A) - t) + ((1-k)overline(A) - t)^2 ] $

  观察展开后的三项：
  1. 第一项：$(1 - k)^2 sum_(i=1)^N (A(i) - overline(A))^2$。根据方差定义 $sigma^2(A) = 1/N sum_(i=1)^N (A(i) - overline(A))^2$，该项等于 $(1 - k)^2 N sigma^2(A)$。
  2. 第二项： $sum_(i=1)^N (A(i) - overline(A))=0$
  3. 第三项：常数项 $((1-k)overline(A) - t)^2$ 累加 $N$ 次，变为 $N[(1-k)overline(A) - t]^2$。

  将上述结果合并，提取公因数 $N$，我们得到最终的 SSD 表达式：
  $ S S D(A, B') &=  (1 - k)^2 sigma^2(A) + [(1 - k)overline(A) - t]^2\ &=(1-k)^2(sigma^2(A)+overline(A)^2)-2t(1-k)overline(A)+t^2  $




#pagebreak()

#problem(2)[
  对于图像 $A = [18, 97]$ 和 $B = [97, 18]$。

  + 计算 $H(A)$ 和 $H(B)$ （结果保留 $log(m)$ 的形式，$m in NN$，例如 $3 log(5) + 2 log(6)$）。
  + 计算 $I(A, B)$ 和 $N M I(A, B) = (H(A)+H(B)) / H(A,B)$。
  + 如果图像添加了更多背景：$A' = [18, 97, 0, 0, ..., 0]$ 和 $B' = [97, 18, 0, 0, ..., 0]$ （各包含 $N$ 个额外的 $0$），计算 $I(A', B')$ 和 $N M I(A', B')$，并讨论为什么 $N M I$ （归一化互信息）被更频繁地使用？
]

#SOLUTION

1. 

  对于图像 $A = [18, 97]$，总像素数为 2。像素值 18 和 97 各出现 1 次。
  因此，概率分布为 $p_A (18) = 1/2$, $p_A (97) = 1/2$。
  信息熵的计算公式为 $H(X) = - sum p(x) log(p(x))$：
  $ H(A) = - (1/2 log(1/2) + 1/2 log(1/2)) =  log(2) $
  同理，对于图像 $B = [97, 18]$，概率分布为 $p_B (18) = 1/2$, $p_B (97) = 1/2$。
  $ H(B) = log(2) $

2. 

  为了计算互信息 $I(A, B)$，首先需要计算联合熵 $H(A, B)$。
  图像 $A$ 和 $B$ 对应位置的像素对为 $(18, 97)$ 和 $(97, 18)$，总共 2 对。
  联合概率分布为 $p(18, 97) = 1/2$, $p(97, 18) = 1/2$。
  $ H(A, B) = - (1/2 log(1/2) + 1/2 log(1/2)) = log(2) $
  互信息计算如下：
  $ I(A, B) = H(A) + H(B) - H(A, B) = log(2) + log(2) - log(2) = log(2) $
  归一化互信息 (NMI) 计算如下：
  $ N M I(A, B) = (H(A) + H(B)) / H(A, B) = (2 log(2)) / log(2) = 2 $

3. 

  现在 $A' = [18, 97, 0, 0, ..., 0]$ 且 $B' = [97, 18, 0, 0, ..., 0]$，假设增加了 $N$ 个 0，总像素数为 $N+2$。
  边缘概率分布变为：
  $p(18) = 1/(N+2)$, $p(97) = 1/(N+2)$, $p(0) = N/(N+2)$。
  因此：
  $ H(A') = H(B') &= - [ 2 dot 1/(N+2) log(1/(N+2)) + N/(N+2) log(N/(N+2)) ]\
  &=2/(N+2)log(N+2)+N/(N+2)log(N+2/(N)) $
  联合概率分布中，像素对为 1 个 $(18,97)$，1 个 $(97,18)$，和 $N$ 个 $(0,0)$。
  $ H(A', B') &= - [ 2 dot 1/(N+2) log(1/(N+2)) + N/(N+2) log(N/(N+2)) ] = H(A')\
  &=2/(N+2)log(N+2)+N/(N+2)log((N+2)/(N))\
  &=log(N+2)-N/(N+2)log N  $
  计算新的互信息和归一化互信息：
  $ I(A', B') = H(A') + H(B') - H(A', B') = 2H(A') - H(A') = H(A') $
  $ N M I(A', B') = (H(A') + H(B')) / H(A', B') = (2H(A')) / H(A') = 2 $

  *为什么 NMI 更常被使用？*

  在医学图像配准中，两幅图像的视场 (FOV) 或重叠区域的大小经常会发生变化（相当于引入了不同数量的背景像素）。从上述计算可以看出，标准互信息 $I(A', B')$ 的值等于 $H(A')$，它会随着背景像素数 $N$ 的变化而改变。然而，归一化互信息 $N M I$ 始终保持为常数 2。这说明 NMI 对图像重叠区域的大小和背景比例具有极强的鲁棒性（即对背景变化不敏感），能够更客观地反映两幅图像的内在相关性，因此在实际配准中比传统的互信息更常被使用。


#pagebreak()

#problem(3)[
  假设空间变换表示为：

  $
  cases(
    x' = sin(x - 2y),
    y' = cos(x + y)
  )
  $

  - 计算雅可比矩阵 (Jacobian matrix)；
  - 计算雅可比行列式 (Jacobian determinant)；
  - 讨论在坐标 $(x, y) = (pi/6, pi/2), (0, (7pi)/6), ((5pi)/6, 0)$ 处的体积变化（膨胀/收缩/不变）。
]

#SOLUTION

*1. 计算雅可比矩阵 (Jacobian Matrix)*

  已知空间变换函数为：
  $ x' = sin(x - 2y) $
  $ y' = cos(x + y) $

  雅可比矩阵 $J$ 由各变量的偏导数组成：
  $ J = mat(
    (partial x') / (partial x), (partial x') / (partial y);
    (partial y') / (partial x), (partial y') / (partial y)
  ) $

  分别对 $x$ 和 $y$ 求偏导数：
  $ (partial x') / (partial x) = cos(x - 2y) dot 1 = cos(x - 2y) $
  $ (partial x') / (partial y) = cos(x - 2y) dot (-2) = -2 cos(x - 2y) $
  $ (partial y') / (partial x) = -sin(x + y) dot 1 = -sin(x + y) $
  $ (partial y') / (partial y) = -sin(x + y) dot 1 = -sin(x + y) $

  因此，雅可比矩阵为：
  $ J = mat(
    cos(x - 2y), -2 cos(x - 2y);
    -sin(x + y), -sin(x + y)
  ) $

  *2. 计算雅可比行列式 (Jacobian Determinant)*

 
  $ |J| &= (cos(x - 2y)) dot (-sin(x + y)) - (-2 cos(x - 2y)) dot (-sin(x + y))\ 
  &= -cos(x - 2y)sin(x + y) - 2cos(x - 2y)sin(x + y)\
  &= -3 cos(x - 2y) sin(x + y) $

  *3. 讨论特定坐标下的体积变化*

  局部体积的变化比例由雅可比行列式的绝对值 $||J||$ 决定：
  - 若 $||J|| > 1$，则体积膨胀 (expansion)；
  - 若 $||J|| < 1$，则体积收缩 (contraction)；
  - 若 $||J|| = 1$，则体积不变 (no change)。

  *情况 (1)：在坐标 $(x, y) = (pi/6, pi/2)$ 处*
  
  代入行列式公式：
  $ |J| = -3 cos(-(5pi)/6) sin((2pi)/3) = -3 dot (-(sqrt(3))/2) dot ((sqrt(3))/2) = 9/4 $
  因为 $||J|| = 9/4 > 1$，所以该点处的体积发生 *膨胀 (expansion)*。

  *情况 (2)：在坐标 $(x, y) = (0, (7pi)/6)$ 处*
  
  代入行列式公式：
  $ |J| = -3 cos(-(7pi)/3) sin((7pi)/6) = -3 dot (1/2) dot (-1/2) = 3/4  $
  因为 $||J|| = 3/4 < 1$，所以该点处的体积发生 *收缩 (contraction)*。

  *情况 (3)：在坐标 $(x, y) = ((5pi)/6, 0)$ 处*
  
  代入行列式公式：
  $ |J| = -3 cos((5pi)/6) sin((5pi)/6) = -3 dot (-(sqrt(3))/2) dot (1/2) = (3sqrt(3))/4 \ $
  因为 $||J|| approx 1.299 > 1$，所以该点处的体积发生 *膨胀 (expansion)*。