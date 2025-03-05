/*
 * filteringAndEvaluation.c
 *
 *  Created on: Apr 22, 2024
 *      Author: hoved
 */

#include "FIR_filter.h"


uint16_t firFilter(uint32_t FIR_buffer[], int FIR_buffer_len,
		uint16_t *FIR_divider, int ringbuffer_ptr, uint16_t newValue) {
	uint32_t out = 0;
	uint32_t j = 0;
	uint32_t k = 0;
	FIR_buffer[ringbuffer_ptr] = (uint32_t) newValue << 10; // scale up to get decimal places
	out = FIR_buffer[ringbuffer_ptr] / FIR_divider[0];
	k++;
	for (j = (ringbuffer_ptr + 1) % FIR_buffer_len; j != ringbuffer_ptr;
			j = ((j + 1) % FIR_buffer_len)) {
		out = out + FIR_buffer[j] / FIR_divider[k];
		k++;

	}
	return out >> 10; //scale down
}

