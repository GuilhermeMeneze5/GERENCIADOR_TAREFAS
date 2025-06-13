import { Component, OnInit } from '@angular/core';
import { PoTableColumn, PoNotificationService } from '@po-ui/ng-components';
import { Task } from './tasks.model';
import { TasksService } from './tasks.service';

@Component({
  selector: 'app-tasks',
  templateUrl: './tasks.component.html'
})
export class TasksComponent implements OnInit {
  tasks: Task[] = [];
  columns: PoTableColumn[] = [
    { property: 'id', label: 'ID' },
    { property: 'title', label: 'Título' },
    { property: 'status', label: 'Status' }
  ];

  legend = [
    { value: '3', color: 'violet', label: 'Concluído' },
    { value: '1', color: 'blue', label: 'Pendente' },
    { value: '2', color: 'green', label: 'Agendamento' },
    { value: '4', color: 'red', label: 'Cancelado' }
  ];

  constructor(
    private tasksService: TasksService,
    private notify: PoNotificationService
  ) {}

  ngOnInit() {
    this.tasksService.getTasks().subscribe(ts => (this.tasks = ts));
  }

  onSave(task: Task) {
    const valid = this.tasksService.validateSubtasks(task);
    this.tasksService.saveTask(valid);
    this.notify.success('Tarefa salva com sucesso!');
  }
}
