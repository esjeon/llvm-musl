; RUN: llc -mtriple=x86_64-unknown-unknown -mcpu=corei7 -mattr=-sse4.1 < %s | FileCheck %s

; Verify that we don't emit packed vector shifts instructions if the
; condition used by the vector select is a vector of constants.

define <4 x float> @test1(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test1:
; CHECK:       # BB#0:
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[1,3]
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test2(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test3(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test4(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test4:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test5(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test5:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test6(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test6:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false>, <8 x i16> %a, <8 x i16> %a
  ret <8 x i16> %1
}

define <8 x i16> @test7(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test7:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test8(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test9(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test9:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test10(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test10:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test11(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test11:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps {{.*#+}} xmm2 = [0,65535,65535,0,65535,65535,65535,65535]
; CHECK-NEXT:    andps %xmm2, %xmm0
; CHECK-NEXT:    andnps %xmm1, %xmm2
; CHECK-NEXT:    orps %xmm2, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 true, i1 true, i1 false, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test12(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test12:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 undef, i1 false, i1 false, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test13(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test13:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllOnes), N1, N2) -> N1
define <4 x float> @test14(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test14:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 undef, i1 true, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test15(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test15:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 undef, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllZeros), N1, N2) -> N2
define <4 x float> @test16(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 undef, i1 false, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test17(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test17:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 undef, i1 undef, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <4 x float> @test18(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test18:
; CHECK:       # BB#0:
; CHECK-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test19(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test19:
; CHECK:       # BB#0:
; CHECK-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test20(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test20:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; CHECK-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test21(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test21:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; CHECK-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @test22(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test22:
; CHECK:       # BB#0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test23(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test23:
; CHECK:       # BB#0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test24(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test24:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test25(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test25:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @select_of_shuffles_0(<2 x float> %a0, <2 x float> %b0, <2 x float> %a1, <2 x float> %b1) {
; CHECK-LABEL: select_of_shuffles_0:
; CHECK:       # BB#0:
; CHECK-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; CHECK-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; CHECK-NEXT:    subps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = shufflevector <2 x float> %a0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %2 = shufflevector <2 x float> %a1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %3 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %2, <4 x float> %1
  %4 = shufflevector <2 x float> %b0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %5 = shufflevector <2 x float> %b1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %6 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %5, <4 x float> %4
  %7 = fsub <4 x float> %3, %6
  ret <4 x float> %7
}

; PR20677
define <16 x double> @select_illegal(<16 x double> %a, <16 x double> %b) {
; CHECK-LABEL: select_illegal:
; CHECK:       # BB#0:
; CHECK-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm4
; CHECK-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm5
; CHECK-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm6
; CHECK-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm7
; CHECK-NEXT:    movaps %xmm7, 112(%rdi)
; CHECK-NEXT:    movaps %xmm6, 96(%rdi)
; CHECK-NEXT:    movaps %xmm5, 80(%rdi)
; CHECK-NEXT:    movaps %xmm4, 64(%rdi)
; CHECK-NEXT:    movaps %xmm3, 48(%rdi)
; CHECK-NEXT:    movaps %xmm2, 32(%rdi)
; CHECK-NEXT:    movaps %xmm1, 16(%rdi)
; CHECK-NEXT:    movaps %xmm0, (%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %sel = select <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x double> %a, <16 x double> %b
  ret <16 x double> %sel
}
