from arguments.helper.cell import Cell
from arguments.collections.propositions import Propositions


class IndexCell(Cell):
    @property
    def proposition_url(self):
        return self.link(Propositions())
