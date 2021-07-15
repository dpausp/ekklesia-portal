import factory
from webtest_helpers import assert_deform, fill_form
from assert_helpers import assert_difference
from ekklesia_portal.datamodel import VotingPhaseType


def test_create_voting_phase_type(client, db_query, voting_phase_type_factory, logged_in_global_admin):
    data = factory.build(dict, FACTORY_CLASS=voting_phase_type_factory)
    res = client.get('/voting_phase_types/+new')
    form = assert_deform(res)
    fill_form(
        form,
        data,
        field_names=['name', 'abbreviation', 'description'],
        enum_field_names=['voting_type']
    )

    with assert_difference(db_query(VotingPhaseType).count, 1):
        form.submit(status=302)


def test_update_voting_phase_type(db_session, client, voting_phase_type_factory, logged_in_global_admin):
    voting_phase_type = voting_phase_type_factory()
    res = client.get(f'/voting_phase_types/{ voting_phase_type.id}/+edit')
    expected = voting_phase_type.to_dict()
    del expected["secret_voting_possible"]
    form = assert_deform(res, expected)
    form['name'] = 'new name'
    form.submit(status=302)
    assert voting_phase_type.name == 'new name'
