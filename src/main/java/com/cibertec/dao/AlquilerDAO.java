package com.cibertec.dao;

import com.cibertec.model.Alquiler;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class AlquilerDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("default");
    
    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    public void insertar(Alquiler alquiler) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(alquiler);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public List<Alquiler> listar() {
        EntityManager em = getEntityManager();
        try {
            // Eagerly fetch detalles to avoid LazyInitializationException
            return em.createQuery("SELECT DISTINCT a FROM Alquiler a LEFT JOIN FETCH a.detalles", Alquiler.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public Alquiler buscar(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Alquiler.class, id);
        } finally {
            em.close();
        }
    }
    
    public void actualizar(Alquiler alquiler) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(alquiler);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void eliminar(Long id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Alquiler alquiler = em.find(Alquiler.class, id);
            if (alquiler != null) {
                em.remove(alquiler);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
} 