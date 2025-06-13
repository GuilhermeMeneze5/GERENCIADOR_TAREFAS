import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Task } from './tasks.model';

@Injectable({ providedIn: 'root' })
export class TasksService {
  private tasks$ = new BehaviorSubject<Task[]>([]);

  constructor() {
    // Simula dados iniciais:
    this.tasks$.next([]);
  }

  getTasks(): Observable<Task[]> {
    return this.tasks$.asObservable();
  }

  saveTask(task: Task) {
    const all = this.tasks$.value.filter(t => t.id !== task.id);
    this.tasks$.next([...all, task]);
  }

  validateSubtasks(task: Task): Task {
    const today = new Date().toISOString().substr(0, 10);
    let hasPending = false;

    task.subtasks = task.subtasks.map(st => {
      if (st.status === '3' && !st.completionDate) {
        // perguntar ao usuário poderia ser dialog, aqui marcou hoje
        st.completionDate = today;
      }
      if (st.completionDate && st.completionDate > today) {
        st.status = '2';
      }
      if (st.status === '1' || st.status === '2') {
        hasPending = true;
      }
      return st;
    });

    if (!hasPending) {
      task.status = '3';
      task.completionDate = today;
    }

    return task;
  }
}
