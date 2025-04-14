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


@pytest.fixture(scope='session')
def session_fixture():
    pass

def not_a_fixture():
    pass

def another_fixture_wrapper():
    @pytest.fixture(autouse=True)
    def delegate():
        pass
    return delegate

@another_fixture_wrapper
def wrapped_autouse_fixture():
    pass
