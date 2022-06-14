# Huffman Coding in python
# with help from: https://www.programiz.com/dsa/huffman-coding


# Creating tree nodes
class NodeTree(object):

    def __init__(self, left=None, right=None):
        self.left = left
        self.right = right

    def children(self):
        return (self.left, self.right)

    def nodes(self):
        return (self.left, self.right)

    def __str__(self):
        return '%s_%s' % (self.left, self.right)


class Huffman:
    # Main function implementing huffman coding
    def huffman_code_tree(node, left=True, binString=''):
        if type(node) is str:
            return {node: binString}
        (l, r) = node.children()
        d = dict()
        d.update(Huffman.huffman_code_tree(l, True, binString + '0'))
        d.update(Huffman.huffman_code_tree(r, False, binString + '1'))

        return d

    # Function to calculate the frequency of each entry in the sequence.
    def frequency_calc(sequence):
        freq = {}
        for entry in sequence:
            if entry in freq:
                freq[entry] += 1
            else:
                freq[entry] = 1

        freq = sorted(freq.items(), key=lambda x: x[1], reverse=True)

        return freq

    # The function that pre-builds the huffman tree.
    def pre_tree_builder(nodes_tuple):
        while len(nodes_tuple) > 1:
            (key1, c1) = nodes_tuple[-1]
            (key2, c2) = nodes_tuple[-2]
            nodes_tuple = nodes_tuple[:-2]
            node = NodeTree(key1, key2)
            nodes_tuple.append((node, c1 + c2))

            nodes_tuple = sorted(nodes_tuple, key=lambda x: x[1], reverse=True)

        return nodes_tuple
