<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="peliculas" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Películas</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#peliculaModal" id="addPeliculaBtn">Agregar Película</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Título</th>
                            <th>Género</th>
                            <th>Stock</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List peliculas = (java.util.List) request.getAttribute("peliculas");
                            if (peliculas != null) {
                                for (Object obj : peliculas) {
                                    com.cibertec.model.Pelicula pelicula = (com.cibertec.model.Pelicula) obj;
                        %>
                        <tr>
                            <td><%= pelicula.getIdPelicula() %></td>
                            <td><%= pelicula.getTitulo() %></td>
                            <td><%= pelicula.getGenero() %></td>
                            <td><%= pelicula.getStock() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#peliculaModal"
                                        data-id="<%= pelicula.getIdPelicula() %>"
                                        data-titulo="<%= pelicula.getTitulo() %>"
                                        data-genero="<%= pelicula.getGenero() %>"
                                        data-stock="<%= pelicula.getStock() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= pelicula.getIdPelicula() %>" data-titulo="<%= pelicula.getTitulo() %>">Eliminar</button>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Pelicula Modal -->
<div class="modal fade" id="peliculaModal" tabindex="-1" aria-labelledby="peliculaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="peliculaForm">
                <input type="hidden" name="accion" id="peliculaAction" value="guardar" />
                <input type="hidden" name="id" id="peliculaId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="peliculaModalLabel">Agregar Película</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="titulo" class="form-label">Título</label>
                        <input type="text" class="form-control" id="titulo" name="titulo" required>
                    </div>
                    <div class="mb-3">
                        <label for="genero" class="form-label">Género</label>
                        <input type="text" class="form-control" id="genero" name="genero" required>
                    </div>
                    <div class="mb-3">
                        <label for="stock" class="form-label">Stock</label>
                        <input type="number" class="form-control" id="stock" name="stock" required min="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post">
                <input type="hidden" name="accion" value="eliminar" />
                <input type="hidden" name="id" id="deletePeliculaId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar la película <span id="deletePeliculaTitulo"></span>?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Pass pelicula id and title to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var titulo = button.getAttribute('data-titulo');
    document.getElementById('deletePeliculaId').value = id;
    document.getElementById('deletePeliculaTitulo').textContent = titulo;
});

// Edit functionality
var peliculaModal = document.getElementById('peliculaModal');
peliculaModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('peliculaModalLabel');
    var actionInput = document.getElementById('peliculaAction');
    var idInput = document.getElementById('peliculaId');
    var tituloInput = document.getElementById('titulo');
    var generoInput = document.getElementById('genero');
    var stockInput = document.getElementById('stock');

    if (button && button.classList.contains('edit-btn')) {
        // Edit mode
        modalTitle.textContent = 'Editar Película';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        tituloInput.value = button.getAttribute('data-titulo');
        generoInput.value = button.getAttribute('data-genero');
        stockInput.value = button.getAttribute('data-stock');
    } else {
        // Add mode
        modalTitle.textContent = 'Agregar Película';
        actionInput.value = 'guardar';
        idInput.value = '';
        tituloInput.value = '';
        generoInput.value = '';
        stockInput.value = '';
    }
});

// Reset modal on close
peliculaModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('peliculaForm').reset();
});
</script> 