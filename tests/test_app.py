import pytest
import json
import os

# Usar un archivo de base de datos real pero exclusivo para pruebas
TEST_DB = "test_tasks.db"
os.environ["DB_PATH"] = TEST_DB

from src.app import app, init_db  # noqa: E402


@pytest.fixture
def client():
    app.config['TESTING'] = True

    # Asegurar un entorno limpio antes de iniciar la prueba
    if os.path.exists(TEST_DB):
        os.remove(TEST_DB)

    init_db()  # Crea la estructura limpia en el archivo de pruebas

    with app.test_client() as client:
        yield client

    # Limpieza al finalizar el test
    if os.path.exists(TEST_DB):
        os.remove(TEST_DB)


def test_index_route(client):
    """1. Validar info de la API"""
    response = client.get('/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['name'] == "To-Do API"


def test_get_all_tasks(client):
    """2. Validar listado de tareas vacio inicial"""
    response = client.get('/tasks')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) == 0


def test_create_task_success(client):
    """3. Validar creacion exitosa de una tarea"""
    payload = {"title": "Laboratorio DevOps", "description": "Pruebas unitarias de la app"}
    response = client.post('/tasks', json=payload)
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['title'] == "Laboratorio DevOps"
    assert data['completed'] == 0


def test_create_task_bad_request(client):
    """4. Validar error 400 si falta el campo obligatorio 'title'"""
    payload = {"description": "Sin titulo"}
    response = client.post('/tasks', json=payload)
    assert response.status_code == 400
    data = json.loads(response.data)
    assert "obligatorio" in data['error']


def test_get_task_not_found(client):
    """5. Validar error 404 para identificadores inexistentes"""
    response = client.get('/tasks/999')
    assert response.status_code == 404
