package com.cibertec.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "alquileres")
public class Alquiler {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alquiler")
    private Long idAlquiler;
    
    @NotNull
    @Column(name = "fecha", length = 20, nullable = false)
    private String fecha;
    
    @NotNull
    @ManyToOne
    @JoinColumn(name = "id_cliente", nullable = false)
    private Cliente cliente;
    
    @NotNull
    @Column(name = "total", nullable = false)
    private Double total;
    
    @NotNull
    @Column(name = "estado", length = 20, nullable = false)
    private String estado;
    
    @OneToMany(mappedBy = "alquiler", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DetalleAlquiler> detalles;
    
    // Getters and Setters
    public Long getIdAlquiler() {
        return idAlquiler;
    }
    
    public void setIdAlquiler(Long idAlquiler) {
        this.idAlquiler = idAlquiler;
    }
    
    public String getFecha() {
        return fecha;
    }
    
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }
    
    public Cliente getCliente() {
        return cliente;
    }
    
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }
    
    public Double getTotal() {
        return total;
    }
    
    public void setTotal(Double total) {
        this.total = total;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public List<DetalleAlquiler> getDetalles() {
        return detalles;
    }
    
    public void setDetalles(List<DetalleAlquiler> detalles) {
        this.detalles = detalles;
    }
} 