#import "@local/tplt:0.2.0": *

#show: BL.with(is-table-cell-stroked: false)
#let ymd = "today"
#let course = "《生物医学图像处理》"
#let proj-name = "Homework 2"

#show: HW.with(
  course: course,
  proj-name: proj-name,
  english: false,
  ymd: ymd,
)

#problem(1)[
1. For an image with size $𝑀 × 𝑁$, prove that multiplying the image with $(−1)^(𝑥+𝑦)$ and applying Fourier transform, the DC component of the result frequency spectrum will in the center $[𝑀/2,N/2]$.
2. What will happen to the spectrum if we replace the $(−1)^(𝑥+y)$ to $(-1)^x$

]
#SOLUTION

1. $ F(u,v)&=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi (u x/M+v y/N))(-1)^(x+y)\
   &=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi (u x/M+v y/N))e^(j pi x)e^(j pi y)\
   &=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi (u x/M+v y/N))e^(j 2 pi(x/M M/2+ y/N N/2))\
   &=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi [(u-M/2) x/M+(v-N/2) y/N]) $

因此，直流分量在频域平移到中心$[M/2,N/2]$

2. $ F(u,v)&=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi (u x/M+v y/N))(-1)^(x)\
   &=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi (u x/M+v y/N))e^(j pi x)\
   &=1/(M N)sum_(x=0)^(M-1)sum_(y=0)^(N-1)f(x,y)e^(-j 2 pi [(u-M/2) x/M+v y/N]) \ $
因此频域u轴平移$M/2$个单位，频域中心$(M/2,0)$



#pagebreak()
#problem(2)[
 Consider the images shown.

– The image on the right was obtained by:

(a) computing the DFT and shift DC component to center

(b) inverse the magnitude

(c) computing the inverse DFT

– Explain (mathematically) why the image on the right appears as it 
does.
#image("pics/2.png",width: 50%)
]
#SOLUTION 

(a)从第一题可得，(a)的操作相当于给$f(x,y)×(-1)^(x+y)$再做DFT,

$ f'(x,y)=f(x,y)(-1)^(x+y) $
$ F'(u,v)=cal(F){f'(x,y)} $

(b)$ F''(u,v)=-F'(u,v) $

(c)按照一般情况推测，执行IDFT时应当再次乘上$(-1)^(x+y)$

$ f''(x,y)=cal(F)^(-1){-F'(u,v)}=-f(x,y)(-1)^2(x+y)=-f(x,y) $



因此，在最终图像中呈现为黑色变白色，白色变黑色。




#pagebreak()
#problem(3)[

1. Proving that for real image $𝑓(𝑥, 𝑦)$, the DFT result $𝐹(𝑢, 𝑣)$ satisfies property $𝐹(𝑢, 𝑣) = 𝐹^∗(−𝑢, −𝑣)$

2. For a 2D MR image, if the $"𝐹𝑂𝑉"_𝑥 = "𝐹𝑂𝑉"_𝑦 = 240$$"𝑚𝑚"$, and max($𝑘_𝑥$) = max $(𝑘_𝑦)$ = 120 $"𝑟𝑎𝑑/𝑚"$, 
   
 Calculate the total number of full sampling pixels (total k-space sampling points) required according to Nyquist criterion?

3. If we use conjugate symmetry property, calculate the minimum number of required k-space sampling pixels for problem 2.

]
#SOLUTION

1. 对于实数图像 $f(x,y)$，其满足 $f^*(x,y) = f(x,y)$。
   
   $ F(u,v) = 1/(M N) sum_(x=0)^(M-1) sum_(y=0)^(N-1) f(x,y) e^(-j 2 pi (u x/M + v y/N)) $
   计算 $F^*(-u,-v)$：
   $ F^*(-u,-v) &= [ 1/(M N) sum_(x=0)^(M-1) sum_(y=0)^(N-1) f(x,y) e^(-j 2 pi (-u x/M - v y/N)) ]^* \
                &= 1/(M N) sum_(x=0)^(M-1) sum_(y=0)^(N-1) f^*(x,y) e^(j 2 pi (-u x/M - v y/N)) \
                &= 1/(M N) sum_(x=0)^(M-1) sum_(y=0)^(N-1) f(x,y) e^(-j 2 pi (u x/M + v y/N)) \
                &= F(u,v) $
   即 $F(u,v) = F^*(-u,-v)$ 

2. 根据奈奎斯特采样定理，k空间的采样间隔需满足：
   $ Delta k_x = (2 pi) / "FOV"_x, quad Delta k_y = (2 pi) / "FOV"_y $
   各个方向上所需的完整采样点数 $N$ 为：
   $ N_x &= (2 max(k_x)) / (Delta k_x) = (2 max(k_x) "FOV"_x) / (2 pi) = (max(k_x) "FOV"_x) / pi \
     N_y &= (2 max(k_y)) / Delta k_y = (2 max(k_y) "FOV"_y) / (2 pi) = (max(k_y) "FOV"_y) / pi $
   已知 $"FOV"_x = "FOV"_y = 240 "mm" = 0.24 "m"$，且 $max(k_x) = max(k_y) = 120 "rad/m"$，代入数据得：
   $ N_x = (120 times 0.24) / pi = 28.8 / pi \
     N_y = (120 times 0.24) / pi = 28.8 / pi $
   所以总的全采样点数为：
   $ N_"total" = N_x times N_y = (28.8 / pi)^2 approx 84 $ 

3. 根据第一问证明的共轭对称性，实数图像在 k 空间是一半冗余的。所以理论上只需采集一半的 k 空间数据，未采集的部分可以通过复共轭推导得出。
   因此，理论上的最少采样像素数为：
   $ N_"min" = 1/2 N_"total"   approx 42 $
   



