<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    java.util.List peliculasList = (java.util.List) request.getAttribute("peliculas");
    StringBuilder peliculasJsArray = new StringBuilder();
    if (peliculasList != null && !peliculasList.isEmpty()) {
        for (int i = 0; i < peliculasList.size(); i++) {
            com.cibertec.model.Pelicula pelicula = (com.cibertec.model.Pelicula) peliculasList.get(i);
            peliculasJsArray.append("{ id: \"").append(pelicula.getIdPelicula()).append("\", titulo: \"").append(pelicula.getTitulo()).append("\" }");
            if (i < peliculasList.size() - 1) peliculasJsArray.append(",");
        }
    }
%>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="alquileres" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Alquileres</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#alquilerModal" id="addAlquilerBtn">Nuevo Alquiler</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Fecha</th>
                            <th>Cliente</th>
                            <th>Total</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List alquileres = (java.util.List) request.getAttribute("alquileres");
                            if (alquileres != null) {
                                for (Object obj : alquileres) {
                                    com.cibertec.model.Alquiler alquiler = (com.cibertec.model.Alquiler) obj;
                                    // Build detalles JSON for this alquiler
                                    StringBuilder detallesJson = new StringBuilder("[");
                                    java.util.List detalles = alquiler.getDetalles();
                                    if (detalles != null) {
                                        for (int i = 0; i < detalles.size(); i++) {
                                            com.cibertec.model.DetalleAlquiler det = (com.cibertec.model.DetalleAlquiler) detalles.get(i);
                                            detallesJson.append("{\"idPelicula\": \"").append(det.getPelicula().getIdPelicula())
                                                        .append("\", \"cantidad\": ").append(det.getCantidad()).append("}");
                                            if (i < detalles.size() - 1) detallesJson.append(",");
                                        }
                                    }
                                    detallesJson.append("]");
                                    String detallesJsonEscaped = detallesJson.toString().replace("'", "&#39;");
                        %>
                        <tr>
                            <td><%= alquiler.getIdAlquiler() %></td>
                            <td><%= alquiler.getFecha() %></td>
                            <td><%= alquiler.getCliente().getNombre() %></td>
                            <td><%= alquiler.getTotal() %></td>
                            <td>
                                <span class="badge <%= alquiler.getEstado().equals("ACTIVO") ? "bg-success" : "bg-danger" %>">
                                    <%= alquiler.getEstado() %>
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#alquilerModal"
                                        data-id="<%= alquiler.getIdAlquiler() %>"
                                        data-cliente="<%= alquiler.getCliente().getIdCliente() %>"
                                        data-total="<%= alquiler.getTotal() %>"
                                        data-estado="<%= alquiler.getEstado() %>"
                                        data-detalles='<%= detallesJsonEscaped %>'>Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= alquiler.getIdAlquiler() %>" data-cliente="<%= alquiler.getCliente().getNombre() %>">Eliminar</button>
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

<!-- Add/Edit Alquiler Modal -->
<div class="modal fade" id="alquilerModal" tabindex="-1" aria-labelledby="alquilerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="alquilerForm">
                <input type="hidden" name="accion" id="alquilerAction" value="guardar" />
                <input type="hidden" name="id" id="alquilerId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="alquilerModalLabel">Nuevo Alquiler</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="idCliente" class="form-label">Cliente</label>
                        <select class="form-select" id="idCliente" name="idCliente" required>
                            <option value="">Seleccione un cliente</option>
                            <%
                                java.util.List clientes = (java.util.List) request.getAttribute("clientes");
                                if (clientes != null) {
                                    for (Object obj : clientes) {
                                        com.cibertec.model.Cliente cliente = (com.cibertec.model.Cliente) obj;
                            %>
                            <option value="<%= cliente.getIdCliente() %>"><%= cliente.getNombre() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Detalles de Alquiler</label>
                        <table class="table" id="detalleTable">
                            <thead>
                                <tr>
                                    <th>Película</th>
                                    <th>Cantidad</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-sm btn-success" id="addDetalleBtn">Agregar Detalle</button>
                    </div>
                    <div class="mb-3">
                        <label for="total" class="form-label">Total</label>
                        <input type="number" step="0.01" class="form-control" id="total" name="total" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="estado" class="form-label">Estado</label>
                        <select class="form-select" id="estado" name="estado" required>
                            <option value="ACTIVO">Activo</option>
                            <option value="DEVUELTO">Devuelto</option>
                            <option value="RETRASADO">Retrasado</option>
                        </select>
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
                <input type="hidden" name="id" id="deleteAlquilerId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar el alquiler del cliente <span id="deleteAlquilerCliente"></span>?
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
var peliculas = [<%= peliculasJsArray.toString() %>];

// Pass alquiler id and cliente to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var cliente = button.getAttribute('data-cliente');
    document.getElementById('deleteAlquilerId').value = id;
    document.getElementById('deleteAlquilerCliente').textContent = cliente;
});

// Edit functionality
var alquilerModal = document.getElementById('alquilerModal');
alquilerModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('alquilerModalLabel');
    var actionInput = document.getElementById('alquilerAction');
    var idInput = document.getElementById('alquilerId');
    var clienteInput = document.getElementById('idCliente');
    var totalInput = document.getElementById('total');
    var estadoInput = document.getElementById('estado');
    var detalleTableBody = document.querySelector('#detalleTable tbody');
    // Clear previous rows
    detalleTableBody.innerHTML = '';
    if (button && button.classList.contains('edit-btn')) {
        // Edit mode
        modalTitle.textContent = 'Editar Alquiler';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        clienteInput.value = button.getAttribute('data-cliente');
        totalInput.value = button.getAttribute('data-total');
        estadoInput.value = button.getAttribute('data-estado');
        // Populate detalles
        var detalles = JSON.parse(button.getAttribute('data-detalles'));
        detalles.forEach(function(det) {
            detalleTableBody.appendChild(createDetalleRow(det.idPelicula, det.cantidad));
        });
        updateTotal();
    } else {
        // Add mode
        modalTitle.textContent = 'Nuevo Alquiler';
        actionInput.value = 'guardar';
        idInput.value = '';
        clienteInput.value = '';
        totalInput.value = '';
        estadoInput.value = 'ACTIVO';
        detalleTableBody.innerHTML = '';
    }
});

// Reset modal on close
alquilerModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('alquilerForm').reset();
    document.querySelector('#detalleTable tbody').innerHTML = '';
});

function createDetalleRow(idPelicula, cantidad) {
    var row = document.createElement('tr');
    var peliculaTd = document.createElement('td');
    var select = document.createElement('select');
    select.className = 'form-select';
    select.name = 'idPelicula[]';
    select.required = true;
    var optionDefault = document.createElement('option');
    optionDefault.value = '';
    optionDefault.text = 'Seleccione';
    select.appendChild(optionDefault);
    peliculas.forEach(function(p) {
        var option = document.createElement('option');
        option.value = p.id;
        option.text = p.titulo;
        if (idPelicula && idPelicula == p.id) option.selected = true;
        select.appendChild(option);
    });
    peliculaTd.appendChild(select);
    var cantidadTd = document.createElement('td');
    var inputCantidad = document.createElement('input');
    inputCantidad.type = 'number';
    inputCantidad.className = 'form-control';
    inputCantidad.name = 'cantidad[]';
    inputCantidad.min = 1;
    inputCantidad.required = true;
    if (cantidad) inputCantidad.value = cantidad;
    cantidadTd.appendChild(inputCantidad);
    var accionTd = document.createElement('td');
    var btnRemove = document.createElement('button');
    btnRemove.type = 'button';
    btnRemove.className = 'btn btn-danger btn-sm';
    btnRemove.textContent = 'Eliminar';
    btnRemove.onclick = function() {
        row.remove();
        updateTotal();
    };
    accionTd.appendChild(btnRemove);
    row.appendChild(peliculaTd);
    row.appendChild(cantidadTd);
    row.appendChild(accionTd);
    // Update total on cantidad change
    inputCantidad.addEventListener('input', updateTotal);
    select.addEventListener('change', updateTotal);
    return row;
}

document.getElementById('addDetalleBtn').addEventListener('click', function() {
    var tableBody = document.querySelector('#detalleTable tbody');
    tableBody.appendChild(createDetalleRow());
});

function updateTotal() {
    var total = 0;
    var cantidades = document.getElementsByName('cantidad[]');
    for (var i = 0; i < cantidades.length; i++) {
        var val = parseInt(cantidades[i].value);
        if (!isNaN(val)) total += val;
    }
    document.getElementById('total').value = total;
}
</script> 