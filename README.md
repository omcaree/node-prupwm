node-prupwm
=======
Introduction
------------
node-prupwm is a [Node.js](http://nodejs.org/) module designed to utilise the [Programmable Realtime Unit (PRU)](http://elinux.org/Ti_AM33XX_PRUSSv2) of the [BeagleBone Black](http://beagleboard.org/Products/BeagleBone%20Black) to generate high resolution PWM signals. It is based on my node-pru module which allows Node.js to take control of the PRU. I will eventually turn this in to a fully functioned Node.js module, but for now it is a working example.

The pru directory contains some sample PRU code (pwm.p) which uses PRU0 outputs 0-5 (pins 25, 27, 28, 29, 30 and 31 of the P9 expansion header) as PWM outputs.

main.js is an example of how to execute the PRU code from Javascript.

To run the example you first need to install the node-pru module, instructions [here](https://github.com/omcaree/node-pru). Unfortunately, this is a fairly involved process if your not familiar with the Device Tree of the BBB.

Once you have node-pru installed you can build the PRU code in the pru directory

	ubuntu@arm:~/node-prupwm$ cd pru
	ubuntu@arm:~/node-prupwm/pru$ pasm -b pwm.p


	PRU Assembler Version 0.84
	Copyright (C) 2005-2013 by Texas Instruments Inc.


	Pass 2 : 0 Error(s), 0 Warning(s)

	Writing Code Image of 36 word(s)

Now you're ready to run the example, remember this must be run as root in order to access the PRU

	ubuntu@arm:~/node-prupwm$ sudo node main.js
	AM33XX
	File pru/pwm.bin open passed
	805.00
	810.00
	815.00
	820.00
	...
	
This will continue to cycle through PWM values indefinately, but feel free to modify everything to suit your needs
