/*
 * Sponsored License - for use in support of a program or activity
 * sponsored by MathWorks.  Not for government, commercial or other
 * non-sponsored organizational use.
 * File: _coder_predictFault_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 28-Aug-2017 11:27:58
 */

#ifndef _CODER_PREDICTFAULT_API_H
#define _CODER_PREDICTFAULT_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_predictFault_api.h"

/* Type Definitions */
#ifndef struct_emxArray_char_T_1x7
#define struct_emxArray_char_T_1x7

struct emxArray_char_T_1x7
{
  char_T data[7];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_char_T_1x7*/

#ifndef typedef_emxArray_char_T_1x7
#define typedef_emxArray_char_T_1x7

typedef struct emxArray_char_T_1x7 emxArray_char_T_1x7;

#endif                                 /*typedef_emxArray_char_T_1x7*/

#ifndef struct_sNEKyI23Rp2nKUSrd8YVhHG
#define struct_sNEKyI23Rp2nKUSrd8YVhHG

struct sNEKyI23Rp2nKUSrd8YVhHG
{
  emxArray_char_T_1x7 f1;
};

#endif                                 /*struct_sNEKyI23Rp2nKUSrd8YVhHG*/

#ifndef typedef_cell_wrap_0
#define typedef_cell_wrap_0

typedef struct sNEKyI23Rp2nKUSrd8YVhHG cell_wrap_0;

#endif                                 /*typedef_cell_wrap_0*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void predictFault(real32_T X[6], cell_wrap_0 label[1]);
extern void predictFault_api(const mxArray * const prhs[1], const mxArray *plhs
  [1]);
extern void predictFault_atexit(void);
extern void predictFault_initialize(void);
extern void predictFault_terminate(void);
extern void predictFault_xil_terminate(void);

#endif

/*
 * File trailer for _coder_predictFault_api.h
 *
 * [EOF]
 */
