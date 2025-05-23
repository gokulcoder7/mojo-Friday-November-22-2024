# ===----------------------------------------------------------------------=== #
# Copyright (c) 2025, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #

# RUN: %mojo --debug-level full -D ENABLE_ASSERTIONS %s

# COM: Test with mojo build
# RUN: mkdir -p %t
# RUN: rm -rf %t/gpu-test-tensor
# RUN: %mojo-build -D ENABLE_ASSERTIONS %s -o %t/gpu-test-tensor
# RUN: %t/gpu-test-tensor

from max.driver import (
    Tensor,
    cpu,
    accelerator,
)
from max.tensor import TensorShape
from testing import assert_not_equal


def test_tensors_with_different_devices_are_not_equal():
    tensor1 = Tensor[DType.float32, 2](TensorShape(2, 2))
    tensor2 = Tensor[DType.float32, 2](TensorShape(2, 2))

    tensor1[0, 0] = 0
    tensor1[0, 1] = 1
    tensor1[1, 0] = 2
    tensor1[1, 1] = 3

    tensor2[0, 0] = 0
    tensor2[0, 1] = 1
    tensor2[1, 0] = 2
    tensor2[1, 1] = 3

    tensor2 = tensor2.move_to(accelerator())

    assert_not_equal(tensor1, tensor2)


def test_tensors_on_accelerator_devices_are_not_equal():
    tensor1 = Tensor[DType.float32, 2](TensorShape(2, 2))
    tensor2 = Tensor[DType.float32, 2](TensorShape(2, 2))

    tensor1[0, 0] = 0
    tensor1[0, 1] = 1
    tensor1[1, 0] = 2
    tensor1[1, 1] = 3

    tensor2[0, 0] = 0
    tensor2[0, 1] = 1
    tensor2[1, 0] = 2
    tensor2[1, 1] = 3

    tensor1 = tensor1.move_to(accelerator())
    tensor2 = tensor2.move_to(accelerator())

    assert_not_equal(tensor1, tensor2)


def main():
    test_tensors_with_different_devices_are_not_equal()
    test_tensors_on_accelerator_devices_are_not_equal()
