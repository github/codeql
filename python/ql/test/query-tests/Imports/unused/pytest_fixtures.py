import pytest


@pytest.fixture
def fixture():
    pass

def fixture_wrapper():
    @pytest.fixture
    def delegate():
        pass
    return delegate

@fixture_wrapper
def wrapped_fixture():
    pass

@pytest.fixture(scope='session', autorun=True)
def factory_fixture():
    pass

fixture_instance = factory_fixture()

def not_a_fixture():
    pass
