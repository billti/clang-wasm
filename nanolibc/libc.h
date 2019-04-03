#ifndef __wasm32__
#error This code only targets wasm32
#endif

extern "C" {

void* calloc(size_t num, size_t size);
void* malloc(size_t size);
void* memset( void * ptr, int value, size_t num );
void* memcpy( void * destination, const void * source, size_t num );
void* realloc(void* ptr, size_t size);
void free(void* ptr);
int printf( const char * format, ... );

struct FILE;

using intmax_t = long long int;
using uintmax_t = unsigned long long int;
using intptr_t = int;
using uintptr_t = unsigned int;
using ptrdiff_t = long int;

using va_list = char*;
// Copied from vadefs.h
#define _INTSIZEOF(n)          ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
#define _ADDRESSOF(v) (&const_cast<char&>(reinterpret_cast<const volatile char&>(v)))
#define va_copy(destination, source) ((destination) = (source))
#define va_start(ap, v) ((void)(ap = (va_list)_ADDRESSOF(v) + _INTSIZEOF(v)))
#define va_arg(ap, t)     (*(t*)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)))
#define va_end(ap)        ((void)(ap = (va_list)0))
}
