"""
    Low-Power System Design Homework.
    Implementation of different approaches of reducing bit transition.
    Credits belong to Ali Negary.
"""

import random
from copy import deepcopy


def hamming_calculator(first_list, second_list, iterations):
    """
    gets two list of numbers and number of bits to process. then calculates hamming distance.
    """
    return [0 if first_list[bit] == second_list[bit] else 1 for bit in range(iterations)].count(1)


def sequence_creator(bit_count, input_count):
    """
    generates sequence of data.
    :param bit_count: number of bits inside each input_data.
    :param input_count: length of the sequence.
    :return: a sequence of data containing zeros and ones.
    """
    input_sequence = []
    for i in range(input_count):
        input_sequence.append([round(random.uniform(0, 1)) for j in range(bit_count)])
    return input_sequence


def transition_counter(input_sequence, bit_count):
    """

    :param input_sequence: a sequence of data containing zeros and ones.
    :param bit_count: number of data bits.
    :return: 2 items: 1) list of transition counts, 2) average of transition counts.
    """
    hamming_distances = []
    for index in range(len(input_sequence) - 1):
        hamming_distances.append(
            hamming_calculator(input_sequence[index], input_sequence[index + 1], iterations=bit_count))
    info = {"transitions": hamming_distances,
            "sum": sum(hamming_distances),
            "average": round(sum(hamming_distances) / len(hamming_distances), 3)}
    return info


def partitioner(data, partition_count):
    """
    converts an array of data into partitions.
    """
    bits = len(data[0])
    partition_size = int(bits / partition_count)
    for index in range(len(data)):
        data[index] = [data[index][i:i + partition_size] for i in range(0, bits, partition_size)]
    return data, partition_size


def bus_invert(input_sequence, bit_count):
    """
    calculates the Hamming Distance between two consecutive inputs and inverts it if condition is met.
    :param input_sequence: a sequence of data containing zeros and ones.
    :param bit_count: number of data bits.
    :return: processed sequence of data containing zeros and ones.
    """
    new_transitions = []
    data_sequence = deepcopy(input_sequence)
    for index in range(len(data_sequence) - 1):
        hamming_distance = hamming_calculator(data_sequence[index], data_sequence[index + 1], iterations=bit_count)
        if hamming_distance < bit_count / 2:
            data_sequence[index].append(0)
        else:
            data_sequence[index] = [1 if bit == 0 else 0 for bit in data_sequence[index]]
            data_sequence[index].append(1)
        new_transitions.append(hamming_calculator(data_sequence[index],
                                                  data_sequence[index + 1],
                                                  iterations=bit_count))
    data_sequence[-1].append(0)

    info = {"transitions": new_transitions,
            "sum": sum(new_transitions),
            "average": round(sum(new_transitions) / len(new_transitions), 3)}
    return data_sequence, info


def partitioned_bus_invert(input_sequence, bit_count, partition_count):
    """
    spits each input in the sequence of data and then tries the bus invert algorithm on them.
    :param input_sequence: a sequence of data containing zeros and ones.
    :param partition_count: number of partitions to split data.
    :param bit_count: number of data bits.
    :return: partitioned sequence of data containing zeros and ones.
    """
    new_transitions = []
    data_sequence = deepcopy(input_sequence)
    # p_d_s = partitioned_data_sequence
    p_d_s, partition_size = partitioner(data=data_sequence, partition_count=partition_count)
    for d_index in range(len(p_d_s) - 1):
        transitions = 0
        for v_index in range(len(p_d_s[d_index])):
            hamming_distance = hamming_calculator(p_d_s[d_index][v_index],
                                                  p_d_s[d_index + 1][v_index],
                                                  iterations=partition_size)
            if hamming_distance < partition_size / 2:
                p_d_s[d_index][v_index].append(0)
            else:
                p_d_s[d_index][v_index] = [1 if bit == 0 else 0 for bit in p_d_s[d_index][v_index]]
                p_d_s[d_index][v_index].append(1)
            transitions += hamming_calculator(p_d_s[d_index][v_index],
                                              p_d_s[d_index + 1][v_index],
                                              iterations=partition_size)
        new_transitions.append(transitions)
    for index in range(len(p_d_s[-1])):
        p_d_s[-1][index].append(0)

    info = {"transitions": new_transitions,
            "sum": sum(new_transitions),
            "average": round(sum(new_transitions) / len(new_transitions), 3)}
    return p_d_s, info


def rotate_by_one(input_sequence, direction):
    """
    rotates each input in the data sequence by 1 bit in the requested direction.
    :param input_sequence: a sequence of data containing zeros and ones.
    :param direction: either "left" or "right" is acceptable.
    :return:
    """
    data_sequence = deepcopy(input_sequence)
    if direction == 'left':
        for data in data_sequence:
            data[:-1], data[-1] = data[1:], data[0]
    elif direction == 'right':
        for data in data_sequence:
            data[0], data[1:] = data[-1], data[:-1]
    else:
        raise ValueError
    return data_sequence


def array_reorder(data_array):
    n = int(len(data_array) / 2)
    data_array[:n], data_array[n:] = data_array[n:], data_array[:n]
    return data_array


def reordering(input_sequence, bit_count, window_size):
    """
    splits data into parts called window and replaces the windows.
        input: [x,y,z,w], window_size = 2   ==>   output: [z,w,x,y]
    :param input_sequence: a sequence of data containing zeros and ones.
    :param bit_count: number of data bits.
    :param window_size: number of values in each window.
    :return: reordered sequence of data.
    """
    data_sequence = deepcopy(input_sequence)
    offset = 2 * window_size
    for d_index, data in enumerate(data_sequence):
        for w_index in range(int(bit_count / offset)):
            data[w_index * offset:(w_index + 1) * offset] = array_reorder(data[w_index * offset:(w_index + 1) * offset])

    info = transition_counter(input_sequence=data_sequence, bit_count=bit_count)
    return data_sequence, info


def printer(list_of_sequences):
    for seq in list_of_sequences:
        print(seq)


if __name__ == "__main__":
    number_of_bits = 8
    number_of_inputs = 4
    total_sequence_size = number_of_bits * number_of_inputs
    partition_factors = [2, 4, 8]

    # create a sequence of data.
    sequence = sequence_creator(bit_count=number_of_bits, input_count=number_of_inputs)
    print("============= Sequence of Data =============")
    printer(sequence)

    # calculate the transitions of an unoptimized sequence.
    unoptimized_sequence_t_c = transition_counter(input_sequence=sequence, bit_count=number_of_bits)
    print("Count of transition without any optimization performed on the data:\n",
          unoptimized_sequence_t_c,
          "\nThere is no optimization overhead.")

    # minimum average transition up to this point.
    min_ave_transition = unoptimized_sequence_t_c['average']
    best_phase = "unoptimized"

    # calculate the transitions of an optimized sequence with bus invert.
    optimized_bus_invert = bus_invert(input_sequence=sequence, bit_count=number_of_bits)
    overhead = ((number_of_inputs + total_sequence_size) / total_sequence_size - 1) * 100
    print("============= Bus Inverted Sequence of Data (1 partition) =============")
    printer(optimized_bus_invert[0])
    print("Count of transition with bus invert:\n",
          optimized_bus_invert[1],
          f"\nThere is 1 bit overhead per data and {number_of_inputs} bits overhead for total {total_sequence_size}" +
          f"bits of data ({overhead}% overhead).")

    # minimum average transition up to this point.
    if optimized_bus_invert[1]['average'] < min_ave_transition:
        min_ave_transition = optimized_bus_invert[1]['average']
        best_phase = "optimized bus invert"
    b_p_s = 1  # best_partition_size

    # calculate the transitions of an optimized sequence with partitioned bus invert.
    for p_factor in partition_factors:
        optimized_partitioned_bus_invert = partitioned_bus_invert(input_sequence=sequence,
                                                                  bit_count=number_of_bits,
                                                                  partition_count=p_factor)
        overhead = ((p_factor * number_of_inputs + total_sequence_size) / total_sequence_size - 1) * 100
        print(f"============= {p_factor} Partition Bus Inverted Sequence of Data =============")
        printer(optimized_partitioned_bus_invert[0])
        print("Count of transition with bus invert:\n",
              optimized_partitioned_bus_invert[1],
              f"\nThere are {p_factor} bits overhead per data and {p_factor * number_of_inputs}" +
              f" bits overhead for total {total_sequence_size} bits of data " +
              f"({overhead}% overhead).")

        # minimum average transition up to this point.
        if optimized_partitioned_bus_invert[1]['average'] < min_ave_transition:
            min_ave_transition = optimized_partitioned_bus_invert[1]['average']
            b_p_s = p_factor  # best_partition_size

    print(f"\nBest partition size is {b_p_s}. its average is {min_ave_transition}.")

    # calculate the transitions of an optimized sequence with rotated then partitioned bus invert.
    directions = ['right', 'left']
    for direction in directions:
        rotated_sequence = rotate_by_one(input_sequence=sequence, direction=direction)
        # rotated optimized partitioned bus invert.
        r_o_p_b_i = partitioned_bus_invert(input_sequence=rotated_sequence,
                                           bit_count=number_of_bits,
                                           partition_count=b_p_s)
        overhead = ((b_p_s * number_of_inputs + total_sequence_size + 1) / total_sequence_size - 1) * 100
        print(f"============= {b_p_s} Partition {direction}-Rotated Bus Inverted Sequence of Data =============")
        printer(r_o_p_b_i[0])
        print("Count of transition with bus invert:\n",
              r_o_p_b_i[1],
              f"\nThere are {b_p_s} bits overhead per data and {b_p_s * number_of_inputs}" +
              f" bits overhead for total {total_sequence_size} bits of data " +
              f"({overhead}% overhead).")

    # calculate the transitions of an optimized sequence with reordering.
    window_sizes = [2, 4]
    for window in window_sizes:
        reordered_sequence = reordering(input_sequence=sequence, bit_count=number_of_bits, window_size=window)

        overhead = ((number_of_inputs + total_sequence_size) / total_sequence_size - 1) * 100
        print(f"============= Reordered Sequence of Data with windows of size {window} bits =============")
        printer(reordered_sequence[0])
        print("Count of transition with bus invert:\n",
              reordered_sequence[1],
              f"\nThere are 1 bits overhead per data and {number_of_inputs}" +
              f" bits overhead for total {total_sequence_size} bits of data " +
              f"({overhead}% overhead).")

        # minimum average transition up to this point.
        if reordered_sequence[1]['average'] < min_ave_transition and overhead < 50:
            min_ave_transition = reordered_sequence[1]['average']

    print(f"\n Minimum average is {min_ave_transition}.")
