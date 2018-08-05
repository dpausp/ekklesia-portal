from unittest.mock import Mock
from pytest import fixture
from ekklesia_portal.concepts.proposition.proposition_cells import PropositionCell
from ekklesia_portal.database.datamodel import ArgumentRelation


@fixture
def proposition_cell(app, proposition_with_arguments):
    return PropositionCell(proposition_with_arguments, Mock())


def test_proposition_cell(proposition_cell):
    assert proposition_cell.argument_count == 3
    assert len(proposition_cell.pro_argument_relations) == 2
    assert len(proposition_cell.contra_argument_relations) == 1
    assert isinstance(proposition_cell.pro_argument_relations[0], ArgumentRelation)
    assert isinstance(proposition_cell.contra_argument_relations[0], ArgumentRelation)