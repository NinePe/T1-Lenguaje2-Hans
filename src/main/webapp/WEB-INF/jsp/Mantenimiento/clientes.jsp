<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="clientes" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Clientes</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#clienteModal" id="addClienteBtn">Agregar Cliente</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Email</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List clientes = (java.util.List) request.getAttribute("clientes");
                            if (clientes != null) {
                                for (Object obj : clientes) {
                                    com.cibertec.model.Cliente cliente = (com.cibertec.model.Cliente) obj;
                        %>
                        <tr>
                            <td><%= cliente.getIdCliente() %></td>
                            <td><%= cliente.getNombre() %></td>
                            <td><%= cliente.getEmail() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#clienteModal"
                                        data-id="<%= cliente.getIdCliente() %>"
                                        data-nombre="<%= cliente.getNombre() %>"
                                        data-email="<%= cliente.getEmail() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= cliente.getIdCliente() %>" data-nombre="<%= cliente.getNombre() %>">Eliminar</button>
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

<!-- Add/Edit Cliente Modal -->
<div class="modal fade" id="clienteModal" tabindex="-1" aria-labelledby="clienteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="clienteForm">
                <input type="hidden" name="accion" id="clienteAction" value="guardar" />
                <input type="hidden" name="id" id="clienteId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="clienteModalLabel">Agregar Cliente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
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
                <input type="hidden" name="id" id="deleteClienteId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar al cliente <span id="deleteClienteNombre"></span>?
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
// Pass cliente id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var nombre = button.getAttribute('data-nombre');
    document.getElementById('deleteClienteId').value = id;
    document.getElementById('deleteClienteNombre').textContent = nombre;
});

// Edit functionality
var clienteModal = document.getElementById('clienteModal');
clienteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('clienteModalLabel');
    var actionInput = document.getElementById('clienteAction');
    var idInput = document.getElementById('clienteId');
    var nombreInput = document.getElementById('nombre');
    var emailInput = document.getElementById('email');

    if (button && button.classList.contains('edit-btn')) {
        // Edit mode
        modalTitle.textContent = 'Editar Cliente';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        nombreInput.value = button.getAttribute('data-nombre');
        emailInput.value = button.getAttribute('data-email');
    } else {
        // Add mode
        modalTitle.textContent = 'Agregar Cliente';
        actionInput.value = 'guardar';
        idInput.value = '';
        nombreInput.value = '';
        emailInput.value = '';
    }
});

// Reset modal on close
clienteModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('clienteForm').reset();
});
</script> 