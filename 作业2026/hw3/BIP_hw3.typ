#import "@local/tplt:0.2.0": *

#show: BL.with(is-table-cell-stroked: false)
#let ymd = "today"
#let course = "《生物医学图像处理》"
#let proj-name = "Homework 3"

#show: HW.with(
  course: course,
  proj-name: proj-name,
  english: false,
  ymd: ymd,
)

#problem(1)[
  Random noise in MR Images follows a Rician distribution in magnitude images:
  $ p(M|I,sigma) = M/sigma^2 e^(-(M^2+I^2)/(2sigma^2)) I_0 ((M I)/sigma^2) $
  Where $I$ is the true underlying signal intensity, $M$ is the noisy measured magnitude, $sigma^2$ is the noise variance in the complex K-space domain, and $I_0$ is the 0-th order modified Bessel function. 
  $ I_0(0)=1, quad I_0(z) approx e^z/sqrt(2 pi z), quad z >> 1 $
  + Show the derivation when the true signal $I=0$. State its final Probability Density Function (PDF), to prove Rician is similar to Rayleigh in the background.
  + Derive the PDF when the local Signal-to-Noise Ratio (SNR) is high ($I >> sigma$) to prove that it approaches a normal distribution $N(I, sigma^2)$. (Hint: Make good use of approximations)
  + Based on (1) and (2), if you were to design an adaptive Alpha-Trimmed Mean filter, how would you set the value of $d$ for the background area and the tissue area? Just provide a simple qualitative explanation. (In engineering practice, MRI reconstruction often employs non-local filtering. However, the objective of this question is to evaluate your fundamental understanding of the relationship between noise distributions and adaptive filtering strategies.)
]
#SOLUTION
1. 当$I=0$时，$ p(M|I,sigma)=M/sigma^2 e^(-(M^2+I^2)/(2sigma^2)) I_0 (0)=M/sigma^2 e^(-(M^2)/(2sigma^2)) $


已知瑞利分布在背景中的概率密度函数为：
$ p(z) = (2z)/b e^(-z^2/b) quad (z >= 0) $
令 $z = M$, $b = 2sigma^2$，可知两式等价。因此证明了在背景区域，其噪声服从瑞利分布。

1. 当$I>>sigma$时，$(M I)/sigma^2>>1$，因此

$ p(M|I,sigma)=M/sigma^2 e^(-(M^2+I^2)/(2sigma^2)) e^((M I)/sigma^2)/(sqrt(2 pi (M I)/sigma^2))=1/(sigma sqrt(2 pi))sqrt(M/I) e^(-(M^2-2M I+I^2)/(2sigma^2))=1/(sigma sqrt(2 pi))sqrt(M/I) e^((-(M-I)^2)/(2sigma^2)) $

由于$I>>sigma$，因此$M approx I$，所以

$ p(M|I,sigma)=1/(sigma sqrt(2 pi)) e^((-(M-I)^2)/(2sigma^2))~N(I,sigma^2) $

3. 对于背景区域：应该设置较大的 $d$ 值。

由第一问可知，背景区域服从瑞利分布。瑞利分布是一种明显的偏态分布（右偏/长尾），会产生一些孤立的、较亮的假性噪声点。较大的 $d$ 值能让滤波器更接近中值滤波，从而有效剔除这些位于分布尾部的极端噪声值，防止背景被均值拉亮。

对于组织区域：应该设置较小的 $d$ 值。

由第二问可知，组织区域信噪比较高，噪声服从对称的正态分布。对于高斯噪声，均值滤波（$d=0$）是数学上最优的线性无偏估计。因此，使用较小的 $d$ 可以在有效平滑高斯噪声的同时，最大限度地保留组织的解剖学细节。
#pagebreak()
#problem(2)[
  Constrained Least Squares Filtering:
  $ hat(F)(u,v) = [(H^*(u,v))/(|H(u,v)|^2 + gamma |P(u,v)|^2)] G(u,v), quad p(x,y) = mat(0, -1, 0; -1, 4, -1; 0, -1, 0) $
  + Prove that $P(u,v) = 4 - 2 cos((2pi u)/M) - 2 cos((2pi v)/N)$
  + Discuss $gamma = 0$, what does the CLS filter become? $gamma arrow +infinity$, what happens to the restored image?
  + Consider an image degraded by uniform linear motion.
  $ H(u,v) = T/(pi(u a + v b)) sin[pi(u a + v b)] e^(-j pi (u a + v b)) $
  Assume there is slight additive noise $eta(x,y)$ in the motion-blurred image. When we use CLS Filtering, explain why setting $gamma = 10^(-6)$ may be significantly better than $gamma = 0$. Just provide a simple qualitative explanation.
]
#SOLUTION
1. $ P(u,v)&=sum_(x)^(M)sum_(y)^(N)p(x,y)e^(-j 2 pi((u x)/M+(v y)/N))\ &=4-(e^(-j 2 pi v/N)+e^(j 2 pi v/N))-(e^(-j 2 pi u/M)+e^(j 2 pi u/M))\ 
&=4 - 2 cos((2pi u)/M) - 2 cos((2pi v)/N) $

2. 当$gamma=0$时，$ hat(F)(u,v) &= (H^*(u,v))/(|H(u,v)|^2)  G(u,v)\
&=(H^*(u,v))/(H(u,v)H^*(u,v))  G(u,v)\ &=G(u,v)/H(u,v) $

CLS 滤波器退化为了直接逆滤波器。

当 $gamma arrow +infinity$ 时：

   对于 $P(u,v) != 0$ 的高频区域，分母中的 $gamma |P(u,v)|^2$ 项趋于无穷大，导致滤波器增益趋近于 0，图像细节被抹除。恢复出的图像会丢失所有频率信息，图像的像素值趋于0（变成全黑），或者如果是计算中保留了直流分量，图像将变成没有任何细节和边缘的、极其平滑的纯色均匀图像。
   
   由于$P(u,v)$在原点处 $P(0,0) = 4 - 2cos(0) - 2cos(0) = 0$，在该频率点（直流分量）：
   $ hat(F)(0,0) = (H^*(0,0)) / (|H(0,0)|^2 + gamma dot 0) G(0,0) = G(0,0) / H(0,0) $

1. 退化函数 $H(u,v)=T/(pi(u a + v b)) sin[pi(u a + v b)] e^(-j pi (u a + v b)) $ ，这个函数具有周期性的过零点（即在特定的频率上，$sin[pi(u a+v b)] = 0$，导致 $H(u,v) = 0$）。

如果设置 $gamma = 0$（即使用直接逆滤波），重建公式包含除以 $H(u,v)$。在 $H(u,v)$ 接近 0 的频率点，轻微的噪声 $N(u,v)$ 会被极大地放大（即 $N(u,v) / H(u,v) arrow infinity$），这会在图像上放大噪声，完全掩盖真实的图像信息。

如果设置 $gamma = 10^(-6)$，在 $H(u,v) arrow 0$ 的过零点处，分母 $|H(u,v)|^2 + gamma|P(u,v)|^2$ 不再为零，而是由 $gamma|P(u,v)|^2$ 决定值。拉普拉斯算子 $|P(u,v)|^2$ 在高频处是一个较大的正值，避免了分母变为0，压制了高频噪声的无限制放大。

因此， $gamma=10^(-6)$能在有效去除运动模糊的同时控制住噪声，远好于 $gamma = 0$。

#pagebreak()
#problem(3)[
  Suppose an image's degradation function is the convolution of original image and $h(x,y)$ and here assume $x, y$ are continuous.
  $ h(x,y) = (x^2+y^2-2sigma^2)/sigma^4 e^(-(x^2+y^2)/(2sigma^2)) $
  + Prove that the degradation in frequency filed is $H(u,v) = -8pi^3 sigma^2 (u^2+v^2) e^(-2pi^2 sigma^2 (u^2+v^2))$
  + Assume the power spectrum ratio of noise and undegraded image $(S_eta / S_f)$ is the constant parameter $K$, give the transfer function expression of Wiener filter for this image.
]
#SOLUTION

1. $ h(x,y)=((x^2-sigma^2)/(sigma^4)+(y^2-sigma^2)/(sigma^4))e^(-(x^2+y^2)/(2sigma^2)) $

考虑$f(x,y)=e^(-(x^2+y^2)/(2sigma^2))$为高斯函数，高斯函数的二维傅里叶变换仍为高斯函数，查公式得：

$ F(u,v)=2pi sigma^2 e^(-2 pi^2 sigma^2(u^2+v^2)) $

令$f(x,y)$对$x$和$y$求二阶偏导$ (partial f)/(partial x)=-x/(sigma^2)e^(-(x^2+y^2)/(2sigma^2)) ,  (partial^2 f)/(partial x^2)=(x^2-sigma^2)/(sigma^4)e^(-(x^2+y^2)/(2sigma^2)) $

$ (partial f)/(partial y)=-y/(sigma^2)e^(-(x^2+y^2)/(2sigma^2)) ,  (partial^2 f)/(partial y^2)=(y^2-sigma^2)/(sigma^4)e^(-(x^2+y^2)/(2sigma^2)) $

$ h(x,y) = (partial^2 f)/(partial x^2) + (partial^2 f)/(partial y^2) $
因此，$ H(u,v)&=[(j 2 pi u)^2+(j 2 pi v)^2]F(u,v)\ &=-8pi^3sigma^2(u^2+v^2)e^(-2 pi^2 sigma^2(u^2+v^2)) $

2. 第一题所求的$H(u,v)$为纯实数函数，因此维纳函数$ W(u,v)&=1/(H(u,v)) (H^2(u,v))/(H^2(u,v)+S_eta / S_f)\ &= -(8pi^3 sigma^2 (u^2+v^2) e^(-2pi^2 sigma^2 (u^2+v^2)))/(64pi^6 sigma^4 (u^2+v^2)^2 e^(-4pi^2 sigma^2 (u^2+v^2)) + K) $