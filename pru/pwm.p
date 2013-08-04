// Copyright (c) 2013 Owen McAree
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.origin 0
.entrypoint START
#include "pru.hp"

START:
// Preamble to set up OCP and shared RAM
	LBCO	r0, CONST_PRUCFG, 4, 4		// Enable OCP master port
	CLR 	r0, r0, 4					// Clear SYSCFG[STANDBY_INIT] to enable OCP master port
	SBCO	r0, CONST_PRUCFG, 4, 4
	MOV		r0, 0x00000120				// Configure the programmable pointer register for PRU0 by setting c28_pointer[15:0]
	MOV		r1, CTPPR_0					// field to 0x0120.  This will make C28 point to 0x00012000 (PRU shared RAM).
	ST32	r0, r1
// End of preamble
	
	// Fields of shared memory are 
	//	Int 0: 		Total PWM period
	//	Int 1-6:	Pulse width for each channel
LOOP1:
	LBCO	r0, CONST_PRUSHAREDRAM, 0, 24
	SET		r30.t0
	SET		r30.t1
	SET		r30.t2
	SET		r30.t3
	SET		r30.t4
	SET		r30.t5
LOOP2:
		SUB		r0, r0, 1
		SUB		r1, r1, 1
		SUB		r2, r2, 1
		SUB		r3, r3, 1
		SUB		r4, r4, 1
		SUB		r5, r5, 1
		SUB		r6, r6, 1
		QBNE	SKIP1, r1, 0
		CLR		r30.t0
SKIP1:
		QBNE	SKIP2, r2, 0
		CLR		r30.t1
SKIP2:
		QBNE	SKIP3, r3, 0
		CLR		r30.t2
SKIP3:
		QBNE	SKIP4, r4, 0
		CLR		r30.t3
SKIP4:
		QBNE	SKIP5, r5, 0
		CLR		r30.t4
SKIP5:
		QBNE	SKIP6, r6, 0
		CLR		r30.t5
SKIP6:
		QBEQ	LOOP1, r0, 0
		QBA		LOOP2
	
	HALT									// Halt the processor (although we will never get here...)
	