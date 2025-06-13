export interface Subtask {
  id: string;
  status: '1' | '2' | '3' | '4';
  description: string;
  dueDate?: string;
  completionDate?: string;
}

export interface Task {
  id: string;
  title: string;
  status: '1' | '2' | '3' | '4';
  completionDate?: string;
  subtasks: Subtask[];
}
