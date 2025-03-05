/*
 * filteringAndEvaluation.h
 *
 *  Created on: Apr 22, 2024
 *      Author: hoved
 */

#ifndef INC_FILTERINGANDEVALUATION_FILTERINGANDEVALUATION_H_
#define INC_FILTERINGANDEVALUATION_FILTERINGANDEVALUATION_H_
#include "stdint.h"

/**
 *  an implementation of a FIR-filter.
 * @param FIR_buffer array of previous values of  newValue. how the values are stored may change.
 * @param FIR_buffer_len number of elements in fir_buffer.
 * @param FIR_divider divisors in the filter. a value of N indicates 1/N.
 * @param ringbuffer_ptr the position to add the new entry. must be advanced by the user.
 * @param newValue the new value to add.
 * @return the calculated filtered value of newValue.
 */
uint16_t firFilter(uint32_t *FIR_buffer, int FIR_buffer_len,
		uint16_t *FIR_divider, uint32_t ringbuffer_ptr, uint16_t newValue);



#endif /* INC_FILTERINGANDEVALUATION_FILTERINGANDEVALUATION_H_ */