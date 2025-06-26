-- FUNCIONES 
-- 1
delimiter //
create function comprarProducto(idP int, idMP int, idEnvio int, cant int, idUsuarioComprador int) returns text deterministic
begin
	if exists(select estado from Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion 
    where idPublicacion = idP and idMP = MedioPago_idMedioPago and idEnvio = Envio_idEnvio and estado = 'No disponible') then 
		return "La publicacion no esta activa";
	else if exists(select Tipo from Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion 
    where idPublicacion = idP and idMP = MedioPago_idMedioPago and idEnvio = Envio_idEnvio and Tipo = 'Subasta') then
		return "Es una subasta";
	else if exists(select Tipo from Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion 
    where idPublicacion = idP and idMP = MedioPago_idMedioPago and idEnvio = Envio_idEnvio and Tipo = 'Venta directa') then
		insert into Compra value(null, curdate(), cant, null, null, null, idUsuarioComprador);
        return "Compra exitosa";
	else 
		return "Error en la compra";
    end if;
    end if;
    end if;
end //
delimiter ;
drop function comprarProducto;
select comprarProducto(5, 4, 5, 10, 2);
-- 2
delimiter $$
create function cerrarPublicacion(idUsuario int, idP int) returns text deterministic
begin
	if exists(select idPublicacion from Publicacion join VentaDirecta 
    on idPublicacion = Publicacion_idPublicacion join Compra on idVentaDirecta = VentaDirecta_idVentaDirecta 
    where usuarioVendedor = idUsuario and idPublicacion = idP and calificacionVendedor is not null and
    calificacionComprador is not null) then
		update Publicacion set estado = "No disponible" where idPublicacion = idP;
		return 'Se ha cambiado el estado de la publicación';
	else 
		return 'Error, no se cambio el estado de la publicación';
    end if;
end $$
delimiter ;
drop function cerrarPublicacion;
select cerrarPublicacion(1, 1);
-- 3
delimiter &&
create function eliminarProducto(idProd int) returns text deterministic
begin
	if exists(select idProducto from Producto left join Publicacion on Producto_idProducto = idProducto 
    where Producto_idProducto = idProd and idPublicacion is null) then
		delete from Producto where idProducto = idProd;
        return "Producto eliminado";
	else
		return "El producto tiene publicaciones asociadas, no se puede eliminar";
	end if;
end &&
delimiter ;
drop function eliminarProducto;
select eliminarProducto(1);
-- 4
delimiter <<
create function pausarPublicacion(idPubli int) returns text deterministic
begin
	if exists(select idPublicacion from Publicacion where idPublicacion = idPubli and estado != "Pausada") then
		update Publicacion set estado = "Pausada" where idPublicacion = idPubli;
		return "Publicacion pausada exitosamente";
	else if exists(select idPublicacion from Publicacion where idPublicacion = idPubli and estado = "Pausada") then
		return "La publicacion ya esta pausada";
	else
		return "No existe la publicacion";
	end if;
	end if;
end <<
delimiter ;
select pausarPublicacion(1);
-- 5
delimiter //
create function pujarProducto(idPubli int, puja int) returns text deterministic
begin
	if (select Publicacion_idPublicacion from Subasta join Oferta on Subasta_idSubasta = idSubasta 
    where Publicacion_idPublicacion = idPubli and puja > precioOfertado) then
		update Oferta join Subasta on Subasta_idSubasta = idSubasta set precioOferta = puja 
        where Publicacion_idPublicacion = idPubli;
        return "Precio ofertado exitosamente";
	else if (select Publicacion_idPublicacion from Subasta join Oferta on Subasta_idSubasta = idSubasta
    where Publicacion_idPublicacion = idPubli and puja < precioOfertado) then 
		return "El precio para la puja es inferior al mayor precio ofertado";
	else
		return "No existe la publicación";
	end if;
	end if;
end //
delimiter ;
drop function pujarProducto;
select pujarProducto(3, 10000);
-- 6
delimiter &&
create function eliminarCategoria(idCat int) returns text deterministic
begin
	if (select idCategoria from Categoria join Producto on 
    Categoria_idCategoria = idCategoria join Publicacion on 
    Producto_idProducto = idProducto where estado = ""
    and Categoria_idCategoria = idCat) then
		delete from Categoria where idCategoria = idCat;
		return "Categoría eliminada exitosamente";
	else if not exists(select idCategoria from Categoria where idCategoria = idCat) then
		return "La categoría no existe";
	else
		return "La categoría tiene publicaciones activas";
end
delimiter ;
-- 7
delimiter %%
create function puntuarComprador(idPubli int, vendedor int, calCompra int, comprador int) returns text deterministic
begin
	if exists(select idPublicacion, usuarioVendedor from Publicacion 
    where usuarioVendedor = vendedor and idPublicacion = idPubli) then
		update Compra set calificacionComprador = calCompra where usuarioComprador = comprador;
		return "Usuario calificado con éxito";
    else 
		return "Error, no existe la publicacion o el usuario vendedor ingresados";
	end if;
end %%
delimiter ;
-- 8
delimiter $$
create function responderPregunta(idVendedor int, respuesta VARCHAR(45)) returns text deterministic
begin
	if (select usuarioVendedor from Publicacion where usuarioVendedor = idVendedor) then
		insert into pregunta value(null, respuesta);
		return "Pregunta respondida exitosamente";
	else 
		return "El DNI del vendedor no coincide con el del dueño de la publicación";
	end if;
end $$
delimiter ;

-- Procedures
-- 1
delimiter //
create procedure buscarPublicacion(in nombreProducto text)
begin 
select idPublicacion, Producto.nombre, precio, Categoria.nombre as nombreCat from Publicacion 
join Producto on idProducto=Producto_idProducto 
join Categoria on idCategoria=Categoria_idCategoria where Producto.nombre=nombreProducto;
end//
delimiter ;
drop procedure buscarPublicacion;
call buscarPublicacion("Bici B4");
-- 2
delimiter //
create procedure crearPublicacion(in PublicacionID int, in tipo text, in fecha date, in estadoP text,
in nivelP text, in precio int, in SubastaID int, in fechaIN date, in fechaF date, in precioF int, 
in idVentaD int, in dir varchar(45), in idMedio int , in envioID int)
begin
insert into Publicacion values(PublicacionID,  tipo, fecha, estadoP, nivel, precio,  null, null);
if tipo = "Venta Directa" then insert into VentaDirecta values(idVentaD, dir, idMedio, envioID, PublicacionID);
else if tipo = "Subasta" then insert into Subasta values(SubastaID, fechaIN, fechaF, precioF, PublicacionID);
end if;
end if;
end//
delimiter ;
drop procedure crearPublicacion;
call crearPublicacion(1, 'Venta directa', '2025-06-01', 'Disponible', 'Bronce', 550, null, null, null, null, 1, 'Av. Siempre Viva 123', 1, 1);

 
-- 3
delimiter //
create procedure verPreguntas(in PublicacionID int)
begin 
select idPreguntas,  pregunta from Pregunta 
where Publicacion_idPublicacion=PublicacionID;
end //
delimiter ;
drop procedure verPreguntas;
call verPreguntas(1);
-- 4
delimiter //
create procedure actualizarReputacionUsuarios()
begin
  declare hayFilas int default false;
  declare Idusuario int default 0;
  declare promcomprador float default 0.0;
  declare promvendedor float default 0.0;
  declare promfinal float default 0.0;
  declare cursorAct cursor for select idusuario from Usuario;
  declare continue handler for not found set hayFilas = true;
  open cursorAct;
  loopAct: loop
    fetch cursorAct into Idusuario;
    if hayFilas then
      leave loopAct;
    end if;
    select avg(calificacionComprador)into promcomprador from Compra where usuarioComprador = Idusuario
    and calificacionComprador is not null;
    
    select avg(calificacionVendedor) into promvendedor from Compra 
    join VentaDirecta on ventadirecta_idventadirecta = idventadirecta
    join Publicacion on publicacion_idpublicacion = idpublicacion
    where Publicacion.usuarioVendedor = Idusuario and calificacionVendedor is not null;
    
    if promcomprador is null and promvendedor is null then set promfinal = 0;
    elseif promcomprador is null then set promfinal = promvendedor;
    elseif promvendedor is null then set promfinal = promcomprador;
    else set promfinal = (promcomprador + promvendedor) DIV 2;
    end if;
    update Usuario set reputacion = promfinal where idUsuario = Idusuario;
  end loop;
  close cursorAct;
end //

delimiter ;
drop procedure actualizarReputacionUsuarios;
call actualizarReputacionUsuarios();

-- 1 
CREATE VIEW pregun AS SELECT idPregunta, pregunta, Publicacion_idPublicacion,
Producto.nombre, Usuario.nombre as nombreU
FROM Pregunta
JOIN Publicacion ON Publicacion_idPublicacion = Publicacion.idPublicacion 
JOIN Usuario ON usuarioPregunta = Usuario.idUsuario 
JOIN Producto ON Producto_idProducto = Producto.idProducto 
WHERE Respuesta_idRespuesta IS NULL 
AND estado = "Disponible";
 
SELECT * FROM pregun;
 
-- 2 
CREATE VIEW Top10cat AS
SELECT Categoria.nombre, COUNT(*) AS d FROM Categoria
JOIN Producto ON Categoria_idCategoria = idCategoria
JOIN Publicacion ON Producto_idProducto = idProducto
WHERE fechaInicio > DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY Categoria.nombre
ORDER BY d DESC
LIMIT 10;
 
SELECT * FROM Top10cat ;
 
-- 3 
CREATE VIEW TopPubli AS SELECT idPublicacion FROM Publicacion
JOIN Pregunta ON Publicacion_idPublicacion = idPublicacion 
WHERE fechaInicio = CURRENT_DATE()
GROUP BY idPublicacion 
ORDER BY count(*) DESC ;
 
SELECT * FROM TopPubli ;
 
-- 4 
CREATE VIEW Vendedor AS SELECT Usuario.nombre , Categoria.nombre as nombreC, idCategoria FROM Usuario 
JOIN Publicacion ON usuarioVendedor = idUsuario 
JOIN Producto ON idProducto = Producto_idProducto
JOIN Categoria ON Categoria_idCategoria = idCategoria 
GROUP BY idCategoria, idUsuario HAVING max(reputacion);
 
SELECT * FROM Vendedor ;
-- Eventos--
-- ej 1--
delimiter //
create event eliminPublicaPausadas on SCHEDULE every 1 week starts now() do
begin
	delete from Publicacion where estado != "Disponible" and fechaInicio >= DATE_SUB(CURDATE(), INTERVAL 90 DAY);
end //
 
delimiter ;
 
-- ej 2--
 
delimiter //
create event Observadas on SCHEDULE every 1 day starts now() do
begin
	update Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion set estado = "Observadas" 
    where estado = "Disponible" and MedioPago_idMedioPago is null;
end //
 
 
-- Triggers
-- ej 1--
delimiter //
create trigger borrarPreguntas before delete on Publicacion for each row
begin
	delete from Pregunta where Publicacion_idPublicacion = old.idPublicacion;
end//
 
 
	
-- ejercicio 2-
-- falta terminar-
delimiter //
create trigger verificarCalificacion after update on Compra for each row 
begin
	declare idV int;
    declare idC int;
	if ( new.calificacionVendedor is not null and new.calificacionComprador is not null) then
		set idV = select usuarioVendedor from Pubicacion 
        join VentaDirecta on Publicacion_idPublicacion = idPublicacion where new.VentaDirecta_idVentaDirecta = idVentaDirecta	
        set idC = select usuarioComprador from Compra ;
	-- Asumimos que tenemos estas 2 funciones--
	call actualizarCalificacionPorUsuario(idC);
	call actualizarCalificacionPorUsuario(idV);
 
	-- --- --- --- --- --- -- -- -- - -- -- -- -- - -- --- --- - --
	end if;
    end if;
end ;
 
delimiter ;
 
 
-- ejercicio 3
delimiter // 
create trigger cambiarCategoria after insert on Compra for each row
begin
		declare VentasH int;
		declare idV int default 0;
		set idV = ( select usuarioVendedor from Pubicacion 
        join VentaDirecta on Publicacion_idPublicacion = idPublicacion where 
        new.VentaDirecta_idVentaDirecta = idVentaDirecta );
		select count(*) into VentasH from Pubicacion join Compra on Publicacion_idPublicacion = idPublicacion
        join VentaDirecta on Publicacion_idPublicacion = idPublicacion where 
        usuarioVendedor = idV;
        if ( VentasH >= 1 and VentasH <= 5) then
			update Usuario set nivel = "Normal";
		else if ( VentasH >= 6 and VentasH <= 10 ) then
			update Usuario set nivel = "Platinum";
		else if ( VentasH >= 11 ) then
			update Usuario set nivel = "Gold";
        end if;
        end if;
        end if;
        end;
	delimiter ;
 
-- Transaccion 1-
delimiter $$
create procedure crearPublicacion (tipo text,fechaI date, Estado text, nvl text, Precio int ,idPR int, idUS int  )
begin
	insert into Publicacion values(tipo, fechaI, Estado, nvl, Precio, idPR, idUS);
    end $$
 
delimiter ;
 
delimiter $$
create procedure crearSubasta (iSubast int, fechaInic date, fechaFi date, precioF int, idPublik int) 
begin	
	start transaction;
	insert into Subasta values (ISubast, fechaInic,fechaFi,precioF,idPublik );
    if exists (select * from VentaDirecta where idPublik = VentaDirecta.Publicacion_idPublicacion ) then
		rollback;  
	else
		commit;
	end if;
	end $$
 
delimiter ;
 
delimiter $$
create procedure crearVentaDirecta (idVD int, dirEnvio text, medioPag int, idEnvio int, idPubli int)
begin
	start transaction;
	insert into VentaDirecta values (idVD,dirEnvio,medioPag,idEnvio,idPubli);
      if exists (select * from VentaDirecta where idPublik = VentaDirecta.Publicacion_idPublicacion ) then
		rollback;  
	else
		commit;  
	end if;
    end $$
 
delimiter ;

-- indices 
create index Indice_producto_nombre on Producto(nombre(255));
explain analyze select * from Publicacion  join Producto  on producto_idproducto = idproducto where nombre = 'bicicleta';
create index Indice_usuario_email on Usuario(email);
create index publicacion_indice on Publicacion(estado);
explain analyze select * from Publicacion where estado = 'Disponible' and nivel = 'Plata';