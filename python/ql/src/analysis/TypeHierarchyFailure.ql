/**
 * @name Inheritance hierarchy cannot be inferred for class
 * @description Inability to infer inheritance hierarchy cannot be inferred for class will impair analysis
 * @id py/failed-inheritance-inference
 * @kind problem
 * @problem.severity info
 */
 
import python


from Class cls
where not exists(ClassObject c | c.getPyClass() = cls)
or
exists(ClassObject c | c.getPyClass() = cls | c.failedInference())
select cls, "Inference of class hierarchy failed for class."