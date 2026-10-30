import pytest

from app.app import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    return app.test_client()


def test_home_contains_student_details(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json["name"] == "Rishav"
    assert response.json["roll_no"] == "2301730245"


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json == {"status": "UP", "version": "1.0.0"}


def test_unknown_route(client):
    assert client.get("/missing").status_code == 404
