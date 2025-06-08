package com.cibertec.servlet;

import com.cibertec.dao.ClienteDAO;
import com.cibertec.model.Cliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ClienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ClienteDAO clienteDAO = new ClienteDAO();
        try {
            List<Cliente> clientes = clienteDAO.listar();
            req.setAttribute("clientes", clientes);
            req.setAttribute("contentPage", "Mantenimiento/clientes.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/clientes.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ClienteDAO clienteDAO = new ClienteDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Cliente cliente = new Cliente();
                cliente.setNombre(req.getParameter("nombre"));
                cliente.setEmail(req.getParameter("email"));
                clienteDAO.insertar(cliente);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Cliente cliente = clienteDAO.buscar(id);
                if (cliente != null) {
                    cliente.setNombre(req.getParameter("nombre"));
                    cliente.setEmail(req.getParameter("email"));
                    clienteDAO.actualizar(cliente);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                try {
                    clienteDAO.eliminar(id);
                } catch (Exception e) {
                    Throwable cause = e.getCause();
                    boolean isConstraint = false;
                    while (cause != null) {
                        if (cause.getClass().getName().contains("ConstraintViolationException")) {
                            isConstraint = true;
                            break;
                        }
                        cause = cause.getCause();
                    }
                    if (isConstraint) {
                        req.getSession().setAttribute("error", "No se puede eliminar el cliente porque tiene alquileres asociados.");
                    } else {
                        req.getSession().setAttribute("error", "Error al eliminar el cliente: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/cliente");
    }
} 