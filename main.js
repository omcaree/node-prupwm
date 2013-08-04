/* Copyright (c) 2013 Owen McAree
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

var pru = require('pru');

// Initialise the PRU
pru.init();

// Set the PWM period in number of PRU cycles (code cycles, not clock cycles!)
//	I determined this value by monitoring the output on an oscilloscope
//	Should also be possible to work it out from number of statements in PRU
//	code
pru.setSharedRAMInt(0, 266666);

// Another number determined from the oscilloscope
//	Also happens to be equal to the above number (PWM period in cycles)
//	divided by 20000 (PWM period in us).
var multiplier = 13.333;

// Start the PRU
pru.execute("pru/pwm.bin");

// Cycle through some PWM values
var step = 5;
var pwm = 800;
setInterval(function() {
	// Update the PRU registers
	pru.setSharedRAMInt(1, multiplier * pwm);
	pru.setSharedRAMInt(2, multiplier * pwm);
	pru.setSharedRAMInt(3, multiplier * pwm);
	pru.setSharedRAMInt(4, multiplier * pwm);
	pru.setSharedRAMInt(5, multiplier * pwm);
	pru.setSharedRAMInt(6, multiplier * pwm);
	
	// Increment and print the value
	pwm+=step;
	console.log(pwm.toFixed(2));
	
	// Reverse the direction when we hit a limit
	if (pwm <= 800 || pwm >= 2200) {
		step *= -1;
	}
}, 100);