/*
 * Sponsored License - for use in support of a program or activity
 * sponsored by MathWorks.  Not for government, commercial or other
 * non-sponsored organizational use.
 * File: _coder_predictFault_api.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 28-Aug-2017 11:27:58
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_predictFault_api.h"
#include "_coder_predictFault_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131450U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "predictFault",                      /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static real32_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *
  parentId))[6];
static real32_T (*c_emlrt_marshallIn(const mxArray *src, const
  emlrtMsgIdentifier *msgId))[6];
static real32_T (*emlrt_marshallIn(const mxArray *X, const char_T *identifier))
  [6];
static const mxArray *emlrt_marshallOut(const cell_wrap_0 u[1]);

/* Function Definitions */

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real32_T (*)[6]
 */
static real32_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier *
  parentId))[6]
{
  real32_T (*y)[6];
  y = c_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
/*
 * Arguments    : const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real32_T (*)[6]
 */
  static real32_T (*c_emlrt_marshallIn(const mxArray *src, const
  emlrtMsgIdentifier *msgId))[6]
{
  real32_T (*ret)[6];
  static const int32_T dims[2] = { 1, 6 };

  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "single", false, 2U,
    dims);
  ret = (real32_T (*)[6])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray *X
 *                const char_T *identifier
 * Return Type  : real32_T (*)[6]
 */
static real32_T (*emlrt_marshallIn(const mxArray *X, const char_T *identifier))
  [6]
{
  real32_T (*y)[6];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(X), &thisId);
  emlrtDestroyArray(&X);
  return y;
}
/*
 * Arguments    : const cell_wrap_0 u[1]
 * Return Type  : const mxArray *
 */
  static const mxArray *emlrt_marshallOut(const cell_wrap_0 u[1])
{
  const mxArray *y;
  int32_T iv0[1];
  int32_T u_size[2];
  int32_T loop_ub;
  int32_T i0;
  const mxArray *b_y;
  char_T u_data[7];
  const mxArray *m0;
  y = NULL;
  iv0[0] = 1;
  emlrtAssign(&y, emlrtCreateCellArrayR2014a(1, iv0));
  u_size[0] = 1;
  u_size[1] = u[0].f1.size[1];
  loop_ub = u[0].f1.size[0] * u[0].f1.size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    u_data[i0] = u[0].f1.data[i0];
  }

  b_y = NULL;
  m0 = emlrtCreateCharArray(2, u_size);
  emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, u_size[1], m0, &u_data[0]);
  emlrtAssign(&b_y, m0);
  emlrtSetCell(y, 0, b_y);
  return y;
}

/*
 * Arguments    : const mxArray * const prhs[1]
 *                const mxArray *plhs[1]
 * Return Type  : void
 */
void predictFault_api(const mxArray * const prhs[1], const mxArray *plhs[1])
{
  real32_T (*X)[6];
  cell_wrap_0 label[1];

  /* Marshall function inputs */
  X = emlrt_marshallIn(emlrtAlias(prhs[0]), "X");

  /* Invoke the target function */
  predictFault(*X, label);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(label);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void predictFault_atexit(void)
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  predictFault_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void predictFault_initialize(void)
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void predictFault_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_predictFault_api.c
 *
 * [EOF]
 */
