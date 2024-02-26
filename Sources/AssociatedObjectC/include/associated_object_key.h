//
//  associated_object_key.h
//  
//
//  Created by p-x9 on 2024/01/26.
//  
//

#ifndef associated_object_key_h
#define associated_object_key_h

#if defined(__wasm__)
// Wasm can't access call frame for security purposes
#define get_return_address() ((void*) 0)
#elif __GNUC__
#define get_return_address() __builtin_return_address(0)
#elif _MSC_VER
#include <intrin.h>
#define get_return_address() _ReturnAddress()
#else
#error missing implementation for get_return_address
#define get_return_address() ((void*) 0)
#endif

#ifdef __GNUC__
#define NOINLINE __attribute__((noinline))
#elif _MSC_VER
#define NOINLINE __declspec(noinline)
#else
#error missing implementation for `NOINLINE`
#define NOINLINE
#endif

const void *_associated_object_key();

#endif /* associated_object_key_h */
