"""
    Low-Power System Design Homework.
    Comparing compressed data using huffman encoding and raw data.
    Credits belong to Ali Negary.
"""

# Steps:
# write a class to do huffman encoding.
# generate two uniformly random numbers with desired number of bits.
# binary add the two sequence of uniformly random numbers to create a sequence of ununiformly random numbers.
# calculate the transisions with and without huffman encoding.

import random
from copy import deepcopy
from pprint import pp, pprint

from hw3_util_huffman import Huffman


def un_uniform_sequence_generator(bit_count, sequence_count):
    """
    generates sequence of data.
    :param bit_count: number of bits inside each input_data.
    :param input_count: length of the sequence.
    :return: a sequence of data containing zeros and ones.
    """
    input_sequence = []
    max_range = 2**bit_count - 1

    for i in range(sequence_count):
        num1 = random.randint(0, max_range)
        num2 = random.randint(0, max_range)
        sum_nums = bin(num1 + num2).replace("0b", "")

        if len(sum_nums) == 5:
            input_sequence.append(sum_nums)
        else:
            input_sequence.append((5 - len(sum_nums)) * "0" + sum_nums)

    input_sequence
    return input_sequence


def sequential_transition_counter(input_sequence):
    """
    :param input_sequence: a sequence of data containing zeros and ones.
    :return: list of transitions, sum and average of them, number of data in the sequence. 
    """

    transitions = []
    # concatenate the whole sequence into a single flat array.
    concaenated_sequence = "".join(input_sequence)

    for index in range(len(concaenated_sequence)-1):
        if concaenated_sequence[index] == concaenated_sequence[index+1]:
            transitions.append(0)
        else:
            transitions.append(1)

    info = {
        # "transitions": transitions,
        "sum": sum(transitions),
        "average per bit": round(sum(transitions) / len(transitions), 3),
        "data count": len(input_sequence),
        "total bit count": len(transitions),
        "average per data": round(sum(transitions) / len(input_sequence), 3)
    }

    return info


def huffman_encoder(raw_data_sequence, ):
    """
    this method will calculate the huffman encoding of the raw data sequence in the input.
    :param raw_data_sequence: a sequence of data containing zeros and ones.
    :return: a sequence of encoded data containing zeros and ones.  
    """
    sequence = deepcopy(raw_data_sequence)
    frequencies = Huffman.frequency_calc(raw_data_sequence)
    pre_built_tree = Huffman.pre_tree_builder(frequencies)
    huffmanned = Huffman.huffman_code_tree(pre_built_tree[0][0])
    for index, data in enumerate(sequence):
        sequence[index] = huffmanned[data]
    return huffmanned, sequence


if __name__ == "__main__":

    data_count = 1000
    num_of_bits = 4
    data_sequence = un_uniform_sequence_generator(
        bit_count=num_of_bits, sequence_count=data_count)
    # print(data_sequence)

    # initial data transisions
    i_d_t = sequential_transition_counter(data_sequence)
    # print(i_d_t)

    huffman_map, encoded_data = huffman_encoder(data_sequence)
    # h_d_t
    h_d_t = sequential_transition_counter(encoded_data)
    # print(h_d_t)

    improvements = {"reduction in data bits: {}%".format(
        round((1 - h_d_t["total bit count"] / i_d_t["total bit count"]) * 100, 2)),
        "reduction in transition bits: {}%".format(
        round((1 - h_d_t["sum"] / i_d_t["sum"]) * 100, 2)),
        "reduction in average transitions per bit: {}%".format(
        round((1 - h_d_t["average per bit"] / i_d_t["average per bit"]) * 100, 2)),
        "reduction in average transitions per data: {}%".format(
        round((1 - h_d_t["average per data"] / i_d_t["average per data"]) * 100, 2))}

    print("=================================================================================================")
    print("The transition details of data without compression:")
    pprint(i_d_t)
    print("=================================================================================================")

    print("The transition details of data with Huffman encoding:")
    pprint(h_d_t)
    print("=================================================================================================")

    print("Overal results of the experiment:")
    pprint(improvements)
    print(f"The above-mentioned results are for a sequence of length {data_count}, " +
          f"each containing [initially] {num_of_bits + 1} bits.")
    print("=================================================================================================")
