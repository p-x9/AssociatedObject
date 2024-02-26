#include "include/associated_object_key.h"

NOINLINE
const void *_associated_object_key() {
    return get_return_address();
}
