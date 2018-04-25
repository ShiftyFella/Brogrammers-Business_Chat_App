import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-chat-form',
  templateUrl: './chat-form.component.html',
  styleUrls: ['./chat-form.component.css']
})
export class ChatFormComponent implements OnInit {

  @Input() chatID: string;  
  
  constructor() { }

  ngOnInit() {
  }

}
