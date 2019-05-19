(* Original from: https://mathoverflow.net/questions/286304/chebyshev-polynomials-of-the-first-kind-and-primality-testing
 * Written by Mamuka Jibladze
 * (https://mathoverflow.net/users/41291/%e1%83%9b%e1%83%90%e1%83%9b%e1%83%a3%e1%83%99%e1%83%90-%e1%83%af%e1%83%98%e1%83%91%e1%83%9a%e1%83%90%e1%83%ab%e1%83%94)
 * Copied here under terms of the Creative Commons Share-Alike license
 * (https://creativecommons.org/licenses/by-sa/4.0/)
 * as specified by the Stack Overflow Public Network Terms of Service
 * (https://stackoverflow.com/legal/terms-of-service#licensing)
 *)

polmul[f_, g_, r_, n_] := Mod[f.NestList[RotateRight, g, r - 1], n]

matmul[a_, b_, r_, n_] :=  Mod[
 {{polmul[a[[1, 1]], b[[1, 1]], r, n] + polmul[a[[1, 2]], b[[2, 1]], r, n], 
   polmul[a[[1, 1]], b[[1, 2]], r, n] + polmul[a[[1, 2]], b[[2, 2]], r, n]}, 
  {polmul[a[[2, 1]], b[[1, 1]], r, n] + polmul[a[[2, 2]], b[[2, 1]], r, n], 
   polmul[a[[2, 1]], b[[1, 2]], r, n] + polmul[a[[2, 2]], b[[2, 2]], r, n]}}, n]

matsq[a_, r_, n_] := matmul[a, a, r, n]

matpow[a_, k_, r_, n_] := If[k == 1, a,
 If[EvenQ[k],
  matpow[matsq[a, r, n], k/2, r, n], 
  matmul[a, matpow[matsq[a, r, n], (k - 1)/2, r, n], r, n]
 ]
]

xmat[r_, n_] :=
 {{PadRight[{0, 2}, r], PadRight[{n - 1}, r]},
  {PadRight[{1}, r], ConstantArray[0, r]}}

isprime[n_] := With[{r = smallestr[n]}, 
 If[r == 0, n == 2,
  With[{xp = matpow[xmat[r, n], n - 1, r, n]},
   Mod[RotateRight[xp[[1, 1]]] + xp[[1, 2]], n]
    === PadRight[Append[ConstantArray[0, Mod[n, r]], 1], r]
  ]
 ]
]

smallestr[n_] := Module[{r},
  If[n==1 || EvenQ[n], Return[0]];
  For[r = 3, MemberQ[{0, 1, r - 1}, Mod[n, r]], r = NextPrime[r + 1],
   If[r < n && Mod[n, r] == 0, Return[0]]
  ];
  r
 ]
