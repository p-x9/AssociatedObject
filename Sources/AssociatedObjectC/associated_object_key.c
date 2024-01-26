//
//  associated_object_key.c
//  
//
//  Created by p-x9 on 2024/01/26.
//  
//

#include "associated_object_key.h"

const void* _associated_object_key() {
    return get_return_address();
}
